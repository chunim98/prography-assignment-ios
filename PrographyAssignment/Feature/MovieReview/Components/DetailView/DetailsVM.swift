//
//  DetailsVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DetailsVM {
    
    struct Input {
        let movieId: Observable<Int>
    }
    
    struct Output {
        let movieDetails: Observable<MovieDetails>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let movieDetails = input.movieId
            .flatMapLatest(fetchMovieDetails(id:))
        
        return Output(movieDetails: movieDetails)
    }
    
    // MARK: Methods
    
    private func fetchMovieDetails(id: Int) -> Observable<MovieDetails> {
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
