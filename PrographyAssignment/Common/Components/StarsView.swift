//
//  StarsView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import SnapKit

final class StarsView: UIView {
    
    // MARK: Components
    
    private let overallHStack = {
        let sv = UIStackView()
        sv.spacing = 4
        return sv
    }()
    
    fileprivate let imageViews: [UIImageView] = {
        Array(0..<5).map { _ in
            let iv = UIImageView()
            iv.image = UIImage(named: "star")?
                .withTintColor(UIColor(hex: 0xB1B1B1))
                .resizeImage(newWidth: 40)
            return iv
        }
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(overallHStack)
        imageViews.forEach { overallHStack.addArrangedSubview($0) }
        
        overallHStack.snp.makeConstraints { $0.centerX.verticalEdges.equalToSuperview() }
        imageViews.forEach { $0.snp.makeConstraints { $0.size.equalTo(16) } }
    }
}

#Preview(traits: .fixedLayout(width: 100, height: 16)) {
    StarsView()
}

// MARK: - Reactive

extension Reactive where Base: StarsView {
    // 점수에 맞게 색 채우기
    var rate: Binder<Int> {
        Binder(base) { base, rate in
            base.imageViews.enumerated().forEach { index, imageView in
                let isSelected = (index+1 <= rate)
                let color = isSelected ? .brandColor : UIColor(hex: 0xB1B1B1)
                imageView.image = imageView.image?.withTintColor(color)
            }
        }
    }
}
