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
    
    struct Input {
        let selectedIndex: Observable<Int>
    }
    
    struct Output {
        let underLinePositionWillUpdate: Observable<CGFloat>
        let colorWillChange: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 언더라인 뷰의 포지션을 맞추기위한 오프셋을 전달
        let underLinePositionWillUpdate = input.selectedIndex
            .map { CGFloat($0) }
        
        // 선택 결과에 따라 세그먼트의 색을 재설정
        let colorWillChange = input.selectedIndex
        
        return Output(
            underLinePositionWillUpdate: underLinePositionWillUpdate,
            colorWillChange: colorWillChange
        )
    }

}
