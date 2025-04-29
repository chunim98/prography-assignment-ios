//
//  DetailVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DetailVM {
    
    struct Input {
        let movieId: Observable<Int>
    }
    
    struct Output {
        let movieDetail: Observable<MovieDetail>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let movieDetail = input.movieId
            .flatMapLatest(fetchMovieDetail(id:))
        
        return Output(movieDetail: movieDetail)
    }
    
    // MARK: Methods
    
    private func fetchMovieDetail(id: Int) -> Observable<MovieDetail> {
        Observable.create { observer in
            Task {
                let fetched = try await TMDBService.shered.fetchMovieDetail(id)
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
