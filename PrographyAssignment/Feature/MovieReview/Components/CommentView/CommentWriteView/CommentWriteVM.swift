//
//  CommentWriteVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa

final class CommentWriteVM {
    
    struct Input {
        let text: Observable<String?>
        let beginEditingEvent: Observable<Void>
        let endEditingEvent: Observable<Void>
    }
    
    struct Output {
        let isPlaceholderHidden: Observable<Bool>
        let updatedText: Observable<String>
        let beginEditingEvent: Observable<Void>
    }
    
    private let bag = DisposeBag()
    
    func trasform(_ input: Input) -> Output {
        
        // 현재 텍스트 외부로 전달
        let updatedText = input.text
            .map { $0 ?? "" }
        
        // 플레이스 홀더 숨김, 표시
        let isPlaceholderHidden = Observable.merge(
            input.beginEditingEvent.map { _ in true },
            input.endEditingEvent.withLatestFrom(updatedText) { _, text in !text.isEmpty }
        )
        
        return Output(
            isPlaceholderHidden: isPlaceholderHidden,
            updatedText: updatedText,
            beginEditingEvent: input.beginEditingEvent
        )
    }
}
