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
        let selectedSegmentIndex: Observable<Int>
    }
    
    struct Output {
        let underLinePositionWillUpdate: Observable<CGFloat>
        let selectedSegmentIndex: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        // 언더라인 뷰의 포지션을 맞추기위한 오프셋을 전달
        let underLinePositionWillUpdate = input.selectedSegmentIndex
            .map { CGFloat($0) }

        // 현재 선택된 세그먼트 인덱스를 외부로 전달
        let selectedSegmentIndex = input.selectedSegmentIndex
        
        return Output(
            underLinePositionWillUpdate: underLinePositionWillUpdate,
            selectedSegmentIndex: selectedSegmentIndex
        )
    }

}
