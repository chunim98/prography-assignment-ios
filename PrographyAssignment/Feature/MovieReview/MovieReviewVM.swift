//
//  MovieReviewVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MovieReviewVM {
    
    struct Input {
        let starButtonsTap: Observable<Int>
        let updatedText: Observable<String>
        let barButtonEvent: Observable<BarButtonEvent>
        let tapGestureEvent: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let movieDetails: Observable<MovieDetails>
        let reviewData: Observable<ReviewData>
        let state: Observable<ReviewState>
        let dismissEvent: Observable<Void>
        let hideKeyBoardEvent: Observable<Void>
    }
    
    private let movieId: Int
    private let bag = DisposeBag()
    
    init(_ movieId: Int) { self.movieId = movieId }
    
    func transform(input: Input) -> Output {
        let reviewState = BehaviorSubject<ReviewState>(value: .create)
        let reviewData = BehaviorSubject(value: ReviewData())
        let dismissEvent = PublishSubject<Void>()
        
        // 영화 아이디로 영화 세부정보 불러오기
        let movieDetails = fetchMovieDetails(movieId).share(replay: 1)

        // 세부정보 받고 저장된 리뷰가 있을 경우, 읽기 상태로 업데이트
        movieDetails
            .map { CoreDataManager.shared.read(movieId: $0.id) }
            .compactMap { $0.map { // 옵셔널 map
                $0.commentData == nil ? ReviewState.readOnlyRate : ReviewState.read
            } }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 세부정보 받고 저장된 리뷰가 있을 경우, 리뷰 데이터 업데이트
        movieDetails
            .compactMap { CoreDataManager.shared.read(movieId: $0.id) }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 편집 상태로 업데이트 (최초 작성은 제외)
        input.starButtonsTap
            .withLatestFrom(reviewState)
            .compactMap { $0 == .create ? nil : ReviewState.edit }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 리뷰 데이터 업데이트
        input.starButtonsTap
            .withLatestFrom(reviewData) {
                $1.updated(personalRate: ($0+1 == $1.personalRate) ? $0 : $0+1)
            }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 코멘트 뷰의 텍스트가 업데이트되면, 편집 상태로 업데이트 (최초 작성은 제외)
        input.updatedText
            .distinctUntilChanged()
            .withLatestFrom(reviewState)
            .compactMap { $0 == .create ? nil : ReviewState.edit }
            .bind(to: reviewState)
            .disposed(by: bag)

        // 코멘트 뷰의 텍스트가 업데이트되면, 리뷰 데이터 업데이트
        input.updatedText
            .distinctUntilChanged()
            .withLatestFrom(reviewData) { text, review in
                review.updated(commentData: review.commentData.map { $0.updated(comment: text) }
                               ?? ReviewData.CommentData(comment: text, date: Date()))
            }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 편집이면, 편집 상태로 업데이트
        input.barButtonEvent
            .compactMap { $0 == .edit ? ReviewState.edit : nil }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 삭제이면, 리뷰 데이터 지우고 화면 닫기
        input.barButtonEvent
            .filter { $0 == .delete }
            .withLatestFrom(reviewData) { CoreDataManager.shared.delete($1) }
            .bind(to: dismissEvent)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 저장이고 최초 작성이면, 리뷰 저장하고 읽기 상태로 업데이트
        input .barButtonEvent
            .withLatestFrom(reviewState) { ($0 == .save) && ($1 == .create) }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(reviewData, movieDetails)) { _, combined in
                let (review, details) = combined
                let commentData = review.commentData.flatMap {
                    $0.comment.isEmpty
                    ? nil : ReviewData.CommentData(comment: $0.comment, date: Date())
                }
                let reviewData = ReviewData(
                    movieId: details.id,
                    posterPath: details.posterPath,
                    personalRate: review.personalRate,
                    date: Date(),
                    title: details.title,
                    commentData: commentData
                )
                
                CoreDataManager.shared.create(with: reviewData)
                return commentData == nil ? ReviewState.readOnlyRate : ReviewState.read
            }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 저장이고 최초 작성이 아니면, 리뷰 갱신하고 읽기 상태로 업데이트
        input .barButtonEvent
            .withLatestFrom(reviewState) { ($0 == .save) && ($1 != .create) }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(reviewData, movieDetails)) { _, combined in
                let (review, details) = combined
                let commentData = review.commentData.flatMap {
                    $0.comment.isEmpty
                    ? nil : ReviewData.CommentData(comment: $0.comment, date: Date())
                }
                let reviewData = ReviewData(
                    movieId: details.id,
                    posterPath: details.posterPath,
                    personalRate: review.personalRate,
                    date: Date(),
                    title: details.title,
                    commentData: commentData
                )
                
                CoreDataManager.shared.update(with: reviewData)
                return commentData == nil ? ReviewState.readOnlyRate : ReviewState.read
            }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 닫기이면, 화면만 닫기
        input.barButtonEvent
            .filter { $0 == .dismiss }
            .map { _ in }
            .bind(to: dismissEvent)
            .disposed(by: bag)
        
        let hideKeyBoardEvent = Observable.merge(
            input.tapGestureEvent.map { _ in },
            input.barButtonEvent.filter { $0 == .save }.map { _ in }
        )
        

        return Output(
            movieDetails: movieDetails,
            reviewData: reviewData.asObservable(),
            state: reviewState.asObservable().distinctUntilChanged(),
            dismissEvent: dismissEvent.asObservable(),
            hideKeyBoardEvent: hideKeyBoardEvent
        )
    }
    
    // MARK: Methods
    
    private func fetchMovieDetails(_ id: Int) -> Observable<MovieDetails> {
        Observable.create { observer in
            Task { @MainActor in
                let fetched = try await TMDBNetworkManager.shered.fetchMovieDetails(id)
                observer.onNext(fetched)
            }
            
            return Disposables.create()
        }
    }
}
