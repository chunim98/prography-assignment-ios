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
        let endEditingEvent: Observable<Void>
        let isCommentWriteViewHidden: Observable<Bool>
        let commentData: Observable<ReviewData.CommentData>
        let isPlaceHolderHidden: Observable<Bool>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let endEditingEvent = input.state
            .filter { [.read, .readOnlyRate].contains($0) }
            .map { _ in }
        
        let isCommentWriteViewHidden = input.state
            .map { $0 == .read }
        
        let commentData = Observable
            .combineLatest(input.state, input.commentData)
            .compactMap { state, data in
                data.flatMap { [.edit, .create].contains(state) ? nil : $0 }
            }
        
        let isPlaceHolderHidden = Observable
            .combineLatest(input.state, input.commentData) {
                let comment = $1?.comment ?? ""
                return ($0 == .edit || !comment.isEmpty)
            }
        
        
        
        return Output(
            endEditingEvent: endEditingEvent,
            isCommentWriteViewHidden: isCommentWriteViewHidden,
            commentData: commentData,
            isPlaceHolderHidden: isPlaceHolderHidden
        )
    }
}
