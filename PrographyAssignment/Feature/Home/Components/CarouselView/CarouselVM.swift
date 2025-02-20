//
//  CarouselVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift

final class CarouselVM {
    
    struct Input {}
    struct Output { let carouselCellDataArr: Observable<[CarouselCellData]> }
        
    func transform(input: Input) -> Output {
        
        // carouselCellDataArr 초기값 설정
        let carouselCellDataArr = fetchMovieList()
            .map { fetched in fetched.map {
                CarouselCellData(
                    backDropPath: $0.backdropPath,
                    title: $0.title,
                    overview: $0.overview,
                    id: $0.id
                )
            } }
        
        return Output(carouselCellDataArr: carouselCellDataArr)
    }
    
    // MARK: Methods
    
    private func fetchMovieList() -> Observable<[MoviesInfo.Result]> {
        Observable.create { observer in
            Task {
                let fetched = try await TMDBService.shered.fetchMovieList(.nowPlaying, 1)
                observer.onNext(fetched.results)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
