//
//  PageTableVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class PageTableVM {
    
    struct Input {
        let nowPlaying: Observable<MovieInfo>
    }
    
    struct Output {
        let nowPlayingListCellDataArr: Observable<[ListCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // nowPlaying 페이지와 데이터 바인딩
        let nowPlayingListCellDataArr = input.nowPlaying
            .map { nowPlaying in
                nowPlaying.results.map {
                    ListCellData(
                        posterPath: $0.posterPath,
                        title: $0.title,
                        overview: $0.overview,
                        voteAverage: $0.voteAverage,
                        genreIDS: $0.genreIDS
                    )
                }
            }
        
        return Output(nowPlayingListCellDataArr: nowPlayingListCellDataArr)
    }

}
