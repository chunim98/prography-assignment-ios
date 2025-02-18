//
//  CommentReadView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift

final class CommentReadView: UIStackView {
    
    // MARK: Components
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let textView = {
        let tv = UITextView()
        tv.text = "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 어쩌구 저쩌구.." // temp
        tv.textContainer.lineFragmentPadding = 0 // 좌우 여백 제거
        tv.textContainerInset = .zero // 상하 여백 제거
        tv.textColor = .textDefault
        tv.font = .pretendardMedium16
        tv.isEditable = false
        tv.isSelectable = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    fileprivate let dateLabel = {
        let label = UILabel()
        label.text = "2025-01-27" // temp
        label.textColor = .textDefault
        label.textAlignment = .right
        label.font = .pretendardRegular11
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 자체 속성 설정
        self.directionalLayoutMargins = .init(horizontal: 16, vertical: 12)
        self.isLayoutMarginsRelativeArrangement = true
        self.backgroundColor = UIColor(hex: 0xEDBAC5, alpha: 0.2)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setLayout() {
        self.addArrangedSubview(overallVStack)
        overallVStack.addArrangedSubview(textView)
        overallVStack.addArrangedSubview(dateLabel)
    }
}

#Preview(traits: .fixedLayout(width: 380, height: 84)) {
    CommentReadView()
}

// MARK: - Reactive

extension Reactive where Base: CommentReadView {
    var commentData: Binder<ReviewData.CommentData> {
        Binder(base) {
            $0.textView.text = $1.comment
            $0.dateLabel.text = $1.date.string
        }
    }
}
