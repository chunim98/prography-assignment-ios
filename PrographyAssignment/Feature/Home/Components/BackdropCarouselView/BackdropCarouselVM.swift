//
//  BackdropCarouselVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift

final class BackdropCarouselVM {
    
    struct Input {
        let nowPlaying: Observable<NowPlaying>
    }
    
    struct Output {
        let carouselCellDataArr: Observable<[CarouselCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // 상위 뷰에서 받아온 NowPlaying타입을 CarouselCellData타입으로 변환
        let carouselCellDataArr = input.nowPlaying
            .map { nowPlaying in
                nowPlaying.results.map {
                    CarouselCellData(
                        title: $0.title,
                        overview: $0.overview,
                        backDropPath: $0.backdropPath
                    )
                }
            }
            .share(replay: 1)
        
        return Output(carouselCellDataArr: carouselCellDataArr)
    }
}
