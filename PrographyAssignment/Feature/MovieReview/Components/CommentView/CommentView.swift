//
//  CommentView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class CommentView: UIView {
    
    // MARK: Properties
    
    private let commentVM = CommentVM()
    private let bag = DisposeBag()
    
    // MARK: Interface
    
    fileprivate let state = PublishSubject<ReviewState>()
    fileprivate let commentData = PublishSubject<ReviewData.CommentData?>()
    
    // MARK: Components
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Comment"
        label.textColor = .textDefault
        label.font = .pretendardBold16
        return label
    }()
    
    fileprivate let commentWriteView = CommentWriteView()
    
    fileprivate let commentReadView = CommentReadView()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(overallVStack)
        overallVStack.addArrangedSubview(titleLabel)
        overallVStack.addArrangedSubview(commentReadView)
        commentReadView.addSubview(commentWriteView)
        
        overallVStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 16))
            $0.height.equalTo(116)
        }
        commentWriteView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setBinding() {
        let input = CommentVM.Input(
            state: state.asObservable(),
            commentData: commentData.asObservable()
        )
        let output = commentVM.transform(input)
        
        // 편집, 최초작성 상태인 경우, 텍스트뷰에 코멘트 데이터를 바인딩하지 않음
        output.commentData
            .bind(to: commentReadView.rx.commentData, commentWriteView.rx.commentData)
            .disposed(by: bag)
        
        // 상태가 읽기로 바뀐 경우, 작성 종료
        output.endEditingEvent
            .bind(with: self) { owner, _ in owner.endEditing(true) }
            .disposed(by: bag)
        
        // 이미 코멘트가 있는 읽기 상태인 경우, 코멘트 작성 뷰를 숨김
        output.isCommentWriteViewHidden
            .bind(to: commentWriteView.rx.isHidden)
            .disposed(by: bag)
        
        // 편집 상태이거나, 코멘트가 비어있지 않은 경우 플레이스 홀더 숨김
        output.isPlaceHolderHidden
            .bind(to: commentWriteView.rx.isPlaceholderHidden)
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 116)) {
    CommentView()
}

// MARK: - Reactive

extension Reactive where Base: CommentView {

    var state: Binder<ReviewState> {
        Binder(base) { $0.state.onNext($1) }
    }
    
    var commentData: Binder<ReviewData> {
        Binder(base) { $0.commentData.onNext($1.commentData) }
    }

    var updatedText: Observable<String> {
        base.commentWriteView.rx.updatedText
    }
    
    var beginEditingEvent: Observable<Void> {
        base.commentWriteView.rx.beginEditingEvent
    }
}
