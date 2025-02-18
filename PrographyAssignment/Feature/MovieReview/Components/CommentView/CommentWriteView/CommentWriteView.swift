//
//  CommentWriteView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class CommentWriteView: UIStackView {
    
    // MARK: Properties
    
    private let commentWriteVM = CommentWriteVM()
    private let bag = DisposeBag()
    
    // MARK: Interface
    
    fileprivate let trimmedTextOut = PublishSubject<String>()
    
    // MARK: Components
    
    fileprivate let textView = {
        let tv = UITextView()
        tv.textContainer.lineFragmentPadding = 0 // 좌우 여백 제거
        tv.textContainerInset = .zero // 상하 여백 제거
        tv.textColor = .textDefault
        tv.font = .pretendardMedium16
        tv.returnKeyType = .done // 키보드 리턴키를 "완료"로 변경
        return tv
    }()
    
    fileprivate let placeholderLabel = {
        let label = UILabel()
        label.text = "후기를 작성해주세요."
        label.textColor = UIColor(hex: 0xB3B3B3)
        label.font = .pretendardMedium16
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 자체 속성 설정
        self.directionalLayoutMargins = .init(horizontal: 16, vertical: 12)
        self.isLayoutMarginsRelativeArrangement = true
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.brandColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        setAutoLayout()
        setBinding()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addArrangedSubview(textView)
        textView.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { $0.leading.top.equalToSuperview() }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = CommentWriteVM.Input(
            text: textView.rx.text.asObservable(),
            didBeginEditing: textView.rx.didBeginEditing.asObservable(),
            didEndEditing: textView.rx.didEndEditing.asObservable()
        )
        let output = commentWriteVM.trasform(input)
        
        // 플레이스홀더 숨김, 표시 바인딩
        output.isPlaceholderHidden
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: bag)
        
        // 좌우 공백이 제거된 텍스트 외부로 방출
        output.trimmedText
            .bind(to: trimmedTextOut)
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 380, height: 84)) {
    CommentWriteView()
}

// MARK: - Reactive

extension Reactive where Base: CommentWriteView {
    var commentData: Binder<ReviewData.CommentData> {
        Binder(base) {
            $0.textView.text = $1.comment
            $0.placeholderLabel.isHidden = true
        }
    }
    
    var endEditing: Binder<Void> {
        Binder(base) { base, _ in base.textView.endEditing(true) }
    }
    
    var updatedText: Observable<String> {
        base.trimmedTextOut.asObservable()
    }
}

