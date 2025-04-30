//
//  TabContentsVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TabContentsVM {
    
    struct Input { let tabIndex: Observable<Int> }
    
    struct Output {
        let tabIndexCGFloat: Observable<CGFloat>
        let tabIndex: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        // CGFloat타입으로 변환해서 현재 탭 인덱스 전달
        let tabIndexCGFloat = input.tabIndex
            .map { CGFloat($0) }
        
        return Output(tabIndexCGFloat: tabIndexCGFloat, tabIndex: input.tabIndex)
    }
    
}
