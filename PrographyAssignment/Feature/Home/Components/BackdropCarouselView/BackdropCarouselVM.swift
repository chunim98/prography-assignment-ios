//
//  BackdropCarouselVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift
import RxCocoa

final class BackdropCarouselVM {
    
    struct Input {
        
    }
    
    struct Output {
        let carouselCellDataArr: Observable<[CarouselCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let carouselCellDataArr = BehaviorSubject(value: MockData.backdropCarousel)
        
        return Output(
            carouselCellDataArr: carouselCellDataArr.asObservable()
        )
    }

}
