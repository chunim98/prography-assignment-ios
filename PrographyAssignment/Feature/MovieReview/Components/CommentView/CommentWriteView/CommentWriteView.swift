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
    
    // MARK: Components
    
    fileprivate let textView = {
        let tv = UITextView()
        tv.textContainer.lineFragmentPadding = 0 // 좌우 여백 제거
        tv.textContainerInset = .zero // 상하 여백 제거
        tv.textColor = .textDefault
        tv.font = .pretendardMedium16
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
}

#Preview(traits: .fixedLayout(width: 380, height: 84)) {
    CommentWriteView()
}

// MARK: - Reactive

extension Reactive where Base: CommentWriteView {
    // 리뷰 수정하거나 할 때 작성된 텍스트가 바인딩 됨
    var commentData: Binder<ReviewData.CommentData> {
        Binder(base) { $0.textView.text = $1.comment }
    }
    
    var isPlaceholderHidden: Binder<Bool> {
        Binder(base) { $0.placeholderLabel.isHidden = $1 }
    }

    var updatedText: Observable<String> {
        base.textView.rx.text.asObservable().map { $0 ?? "" }
    }
    
    var beginEditingEvent: Observable<Void> {
        base.textView.rx.didBeginEditing.asObservable()
    }
}

