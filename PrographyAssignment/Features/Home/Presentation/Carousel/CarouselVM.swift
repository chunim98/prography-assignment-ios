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
    
    private let fetchCarouselCellDataArr =
    FetchCarouselCellDataArrUseCase(DefaultCarouselCellDataRepository())
        
    func transform(input: Input) -> Output {
        
        // carouselCellDataArr 초기값 설정
        let carouselCellDataArr = fetchCarouselCellDataArr.excute()
        
        return Output(carouselCellDataArr: carouselCellDataArr)
    }
}
