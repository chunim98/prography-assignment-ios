//
//  CarouselVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift
import RxCocoa

final class CarouselVM {
    
    struct Input {}
    
    struct Output {
        let carouselCellDataArr: Observable<[CarouselCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let carouselCellDataArr = BehaviorSubject(value: [CarouselCellData]())
        
        // carouselCellDataArr 초기값 설정
        fetchMovieList()
            .map { fetched in fetched.map {
                CarouselCellData(
                    backDropPath: $0.backdropPath,
                    title: $0.title,
                    overview: $0.overview,
                    id: $0.id
                )
            } }
            .bind(to: carouselCellDataArr)
            .disposed(by: bag)
        
        return Output(
            carouselCellDataArr: carouselCellDataArr.asObservable()
        )
    }
    
    // MARK: Methods
    
    private func fetchMovieList() -> Observable<[MoviesInfo.Result]> {
        Observable.create { observer in
            Task {
                #warning("Mock 데이터 사용중2")
                let fetched = try await TMDBNetworkManager.shered.fetchMovieList(.nowPlaying, 1)
//                let fetched = try await TMDBNetworkManager.shered.fetchMovieListMock()
                observer.onNext(fetched.results)
            }
            
            return Disposables.create()
        }
    }
}
