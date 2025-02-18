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

    }
    
    struct Output {
        let movieDetails: Observable<MovieDetails>
        let rate: Observable<Int>
    }
    
    private let movieId: Int
    private let bag = DisposeBag()
    
    init(_ movieId: Int) { self.movieId = movieId }
    
    func transform(input: Input) -> Output {
        let rate = BehaviorSubject(value: 1)
        
        let movieDetails = fetchMovieDetails(movieId)
        
        return Output(movieDetails: movieDetails, rate: rate.asObservable())
    }
    
    // MARK: Methods
    
    private func fetchMovieDetails(_ id: Int) -> Observable<MovieDetails> {
        Observable.create { observer in
            Task {
                let fetched = try await TMDBNetworkManager.shered.fetchMovieDetails(id)
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
