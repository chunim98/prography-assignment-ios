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
        let changedIndex: Observable<Int>
        let panGesture: Observable<UIPanGestureRecognizer>
        let selectedModel: Observable<MovieId>
    }
    
    struct Output {
        let currentIndex: Observable<Int>
        let panGesture: Observable<UIPanGestureRecognizer>
        let movieId: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let currentIndex = BehaviorSubject(value: 0)
        
        // 선택된 인덱스 상태 업데이트
        input.changedIndex
            .bind(to: currentIndex)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        let movieId = input.selectedModel
            .map { $0.id }
        
        return Output(
            currentIndex: currentIndex.asObservable(),
            panGesture: input.panGesture,
            movieId: movieId
        )
    }
}
