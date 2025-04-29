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
        let tappedStarIndex: Observable<Int>
        let updatedText: Observable<String>
        let beginEditingEvent: Observable<Void>
        let barButtonEvent: Observable<BarButtonEvent>
        let tapGesture: Observable<UITapGestureRecognizer>
    }
    
    struct Output {
        let movieDetail: Observable<MovieDetail>
        let reviewData: Observable<ReviewData>
        let state: Observable<ReviewState>
        let dismissEvent: Observable<Void>
        let endEditingEvent: Observable<Void>
    }
    
    private let movieId: Int
    private let bag = DisposeBag()
    
    init(_ movieId: Int) { self.movieId = movieId }
    
    func transform(input: Input) -> Output {
        let reviewState = BehaviorSubject<ReviewState>(value: .create)
        let reviewData = BehaviorSubject(value: ReviewData())
        let dismissEvent = PublishSubject<Void>()
        
        // 영화 아이디로 영화 세부정보 불러오기
        let movieDetail = fetchMovieDetail(movieId).share(replay: 1)

        // 세부정보 받고 저장된 리뷰가 있을 경우, 읽기 상태로 업데이트
        movieDetail
            .map { CoreDataManager.shared.read(movieId: $0.id) }
            .compactMap { $0.map { // 옵셔널 map
                $0.commentData == nil ? ReviewState.readOnlyRate : ReviewState.read
            } }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 세부정보 받고 저장된 리뷰가 있을 경우, 리뷰 데이터 업데이트
        movieDetail
            .compactMap { CoreDataManager.shared.read(movieId: $0.id) }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 편집 상태로 업데이트 (최초 작성은 제외)
        input.tappedStarIndex
            .withLatestFrom(reviewState)
            .compactMap { $0 == .create ? nil : ReviewState.edit }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 리뷰 데이터 업데이트
        input.tappedStarIndex
            .withLatestFrom(reviewData) {
                $1.updated(personalRate: ($0+1 == $1.personalRate) ? $0 : $0+1)
            }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 코멘트 뷰의 작성을 시작하면, 편집 상태로 업데이트 (최초 작성은 제외)
        input.beginEditingEvent
            .withLatestFrom(reviewState)
            .compactMap { $0 == .create ? nil : ReviewState.edit }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 코멘트 뷰의 텍스트가 업데이트되면, 리뷰 데이터 업데이트
        input.updatedText
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
            .withLatestFrom(reviewData) {
                CoreDataManager.shared.delete($1)
                HapticManager.shared.occurSuccess() // 햅틱 피드백 발생
            }
            .bind(to: dismissEvent)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 저장이고 최초 작성이면, 리뷰 저장하고 읽기 상태로 업데이트
        input .barButtonEvent
            .withLatestFrom(reviewState) { ($0 == .save) && ($1 == .create) }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(reviewData, movieDetail)) { _, combined in
                let (review, detail) = combined
                let commentData = review.commentData.flatMap {
                    $0.comment.isEmpty
                    ? nil : ReviewData.CommentData(comment: $0.comment, date: Date())
                }
                let reviewData = ReviewData(
                    movieId: detail.id,
                    posterPath: detail.posterPath,
                    personalRate: review.personalRate,
                    date: Date(),
                    title: detail.title,
                    commentData: commentData
                )
                
                CoreDataManager.shared.create(with: reviewData)
                HapticManager.shared.occurSuccess() // 햅틱 피드백 발생
                return commentData == nil ? ReviewState.readOnlyRate : ReviewState.read
            }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 바 버튼 이벤트가 저장이고 최초 작성이 아니면, 리뷰 갱신하고 읽기 상태로 업데이트
        input .barButtonEvent
            .withLatestFrom(reviewState) { ($0 == .save) && ($1 != .create) }
            .filter { $0 }
            .withLatestFrom(Observable.combineLatest(reviewData, movieDetail)) { _, combined in
                let (review, detail) = combined
                let commentData = review.commentData.flatMap {
                    $0.comment.isEmpty
                    ? nil : ReviewData.CommentData(comment: $0.comment, date: Date())
                }
                let reviewData = ReviewData(
                    movieId: detail.id,
                    posterPath: detail.posterPath,
                    personalRate: review.personalRate,
                    date: review.date,
                    title: detail.title,
                    commentData: commentData
                )
                
                CoreDataManager.shared.update(with: reviewData)
                HapticManager.shared.occurSuccess() // 햅틱 피드백 발생
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
        
        // 화면 아무 곳을 탭하거나, 저장 버튼을 누르면 코멘트 작성 종료
        let endEditingEvent = Observable.merge(
            input.tapGesture.map { _ in },
            input.barButtonEvent.filter { $0 == .save }.map { _ in }
        )
        
        // 별점 건드리는 순간, 햅틱 피드백 발생
        input.tappedStarIndex
            .bind { _ in HapticManager.shared.occurSelect() }
            .disposed(by: bag)

        return Output(
            movieDetail: movieDetail,
            reviewData: reviewData.asObservable(),
            state: reviewState.asObservable().distinctUntilChanged(),
            dismissEvent: dismissEvent.asObservable(),
            endEditingEvent: endEditingEvent
        )
    }
    
    // MARK: Methods
    
    private func fetchMovieDetail(_ id: Int) -> Observable<MovieDetail> {
        Observable.create { observer in
            Task { @MainActor in
                let fetched = try await TMDBService.shered.fetchMovieDetail(id)
                observer.onNext(fetched)
            }
            
            return Disposables.create()
        }
    }
}
