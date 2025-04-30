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
    
    // MARK: Input & Output
    
    struct Input { let movieId: Observable<Int> }
    struct Output { let movieDetail: Observable<MovieDetailDTO> }

    // MARK: Event Handling
    
    func transform(input: Input) -> Output {
        // Use Case
        let fetchMovieDetail = FetchMovieDetailUseCase(DefaultMovieDetailRepository())
        
        let movieDetail = input.movieId.flatMapLatest(fetchMovieDetail.execute(_:))
        
        return Output(movieDetail: movieDetail)
    }
}
