//
//  MovieReviewVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MovieReviewVM {
    
    struct Input {
        let starButtonsTap: Observable<Int>
        let updatedText: Observable<String>
    }
    
    struct Output {
        let movieDetails: Observable<MovieDetails>
        let reviewData: Observable<ReviewData>
        let state: Observable<ReviewState>
    }
    
    private let movieId: Int
    private let bag = DisposeBag()
    
    init(_ movieId: Int) { self.movieId = movieId }
    
    func transform(input: Input) -> Output {
        let reviewState = BehaviorSubject<ReviewState>(value: .create)
        let reviewData = BehaviorSubject(value: ReviewData())
        
        // 영화 아이디로 영화 세부정보 불러오기
        let movieDetails = fetchMovieDetails(movieId).share(replay: 1)

        // 세부정보 받고 저장된 리뷰가 있을 경우, 읽기 상태로 업데이트
        movieDetails
            .map { CoreDataManager.shared.read(movieId: $0.id) }
            .compactMap { $0.map { // 옵셔널 map
                $0.commentData == nil ? ReviewState.read : ReviewState.readOnlyRate
            } }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 세부정보 받고 저장된 리뷰가 있을 경우, 리뷰 데이터 업데이트
        movieDetails
            .compactMap { CoreDataManager.shared.read(movieId: $0.id) }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 편집 상태로 업데이트
        input.starButtonsTap
            .map { _ in ReviewState.edit }
            .bind(to: reviewState)
            .disposed(by: bag)
        
        // 별점 건드리는 순간, 리뷰 데이터 업데이트
        input.starButtonsTap
            .withLatestFrom(reviewData) {
                $1.updated(personalRate: ($0+1 == $1.personalRate) ? $0 : $0+1)
            }
            .bind(to: reviewData)
            .disposed(by: bag)

        // 코멘트 뷰의 텍스트가 업데이트되면, 리뷰 데이터 업데이트
        input.updatedText
            .withLatestFrom(reviewData) { text, review in
                review.updated(commentData: review.commentData.map { $0.updated(comment: text) }
                               ?? ReviewData.CommentData(comment: text, date: Date()))
            }
            .bind(to: reviewData)
            .disposed(by: bag)
        
        return Output(
            movieDetails: movieDetails,
            reviewData: reviewData,
            state: reviewState.asObservable().distinctUntilChanged()
        )
    }
    
    // MARK: Methods
    
    private func fetchMovieDetails(_ id: Int) -> Observable<MovieDetails> {
        Observable.create { observer in
            Task {
                let fetched = try await TMDBNetworkManager.shered.fetchMovieDetails(id)
                observer.onNext(fetched)
            }
            
            return Disposables.create()
        }
    }
}
