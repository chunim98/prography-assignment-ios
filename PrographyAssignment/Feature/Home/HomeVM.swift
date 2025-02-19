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
        let modelSelected: Observable<MovieId>
    }
    
    struct Output {
        let selectedIndex: Observable<Int>
        let panGestureEvent: Observable<UIPanGestureRecognizer>
        let pushMovieReview: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let selectedIndex = BehaviorSubject(value: 0)
        
        // 선택된 인덱스 상태 업데이트
        input.changeIndex
            .bind(to: selectedIndex)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        let pushMovieReview = input.modelSelected
            .map { $0.id }

        return Output(
            selectedIndex: selectedIndex.asObservable(),
            panGestureEvent: input.panGestureEvent,
            pushMovieReview: pushMovieReview
        )
    }
}
