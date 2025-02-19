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
        let didBeginEditing: Observable<Void>
        let didEndEditing: Observable<Void>
    }
    
    struct Output {
        let isPlaceholderHidden: Observable<Bool>
        let trimmedText: Observable<String>
    }
    
    private let bag = DisposeBag()
    
    func trasform(_ input: Input) -> Output {
        
        // 텍스트를 가져와서 시작과 끝 공백을 제거
        let trimmedText = input.text
            .startWith("") // withLatestFrom 때문에 초기값 할당
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .skip(until: input.didBeginEditing)

        // 입력을 시작하면 플레이스홀더 숨김
        // 입력을 끝냈을 때, 텍스트가 입력되어 있지 않다면 플레이스 홀더 표시
        let isPlaceholderHidden = Observable.merge(
            input.didBeginEditing.map { _ in true },
            input.didEndEditing.withLatestFrom(trimmedText) { !$1.isEmpty }
        )

        return Output(
            isPlaceholderHidden: isPlaceholderHidden,
            trimmedText: trimmedText
        )
    }
}
