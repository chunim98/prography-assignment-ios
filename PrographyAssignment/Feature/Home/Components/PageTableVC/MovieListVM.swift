//
//  MovieListVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MovieListVM {
    
    struct Input {
        let listCellDataArr: Observable<[ListCellData]>
    }
    
    struct Output {
        let listCellDataArr: Observable<[ListCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
       
        let listCellDataArr = input.listCellDataArr
        
        return Output(
            listCellDataArr: listCellDataArr
        )
    }
}
