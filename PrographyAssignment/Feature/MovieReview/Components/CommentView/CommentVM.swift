//
//  CommentVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/21/25.
//

import Foundation

import RxSwift
import RxCocoa

final class CommentVM {
    
    struct Input {
        let state: Observable<ReviewState>
        let commentData: Observable<ReviewData.CommentData?>
    }
    
    struct Output {
        let commentData: Observable<ReviewData.CommentData>
        let endEditingEvent: Observable<Void>
        let isCommentWriteViewHidden: Observable<Bool>
        let isPlaceHolderHidden: Observable<Bool>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        // 편집, 최초작성 상태인 경우, 텍스트뷰에 코멘트 데이터를 바인딩하지 않음
        let commentData = Observable
            .combineLatest(input.state, input.commentData)
            .compactMap { state, data in
                data.flatMap { [.edit, .create].contains(state) ? nil : $0 }
            }
        
        // 상태가 읽기로 바뀐 경우, 작성 종료
        let endEditingEvent = input.state
            .filter { [.read, .readOnlyRate].contains($0) }
            .map { _ in }
        
        // 이미 코멘트가 있는 읽기 상태인 경우, 코멘트 작성 뷰를 숨김
        let isCommentWriteViewHidden = input.state
            .map { $0 == .read }
        
        // 편집 상태이거나, 코멘트가 비어있지 않은 경우 플레이스 홀더 숨김
        let isPlaceHolderHidden = Observable
            .combineLatest(input.state, input.commentData) {
                let comment = $1?.comment ?? ""
                return ($0 == .edit || !comment.isEmpty)
            }

        return Output(
            commentData: commentData,
            endEditingEvent: endEditingEvent,
            isCommentWriteViewHidden: isCommentWriteViewHidden,
            isPlaceHolderHidden: isPlaceHolderHidden
        )
    }
}
