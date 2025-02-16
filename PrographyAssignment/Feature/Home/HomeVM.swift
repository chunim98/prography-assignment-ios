//
//  HomeVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import UIKit

import RxSwift
import RxCocoa

final class HomeVM {
    
    struct Input {
        let changeIndex: Observable<Int>
        let panGestureEvent: Observable<UIPanGestureRecognizer>
    }
    
    struct Output {
        let selectedIndex: Observable<Int>
        let panGestureEvent: Observable<UIPanGestureRecognizer>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let selectedIndex = BehaviorSubject(value: 0)
        
        // 선택된 인덱스 상태 업데이트
        input.changeIndex
            .bind(to: selectedIndex)
            .disposed(by: bag)

        return Output(
            selectedIndex: selectedIndex.asObservable(),
            panGestureEvent: input.panGestureEvent
        )
    }
}
