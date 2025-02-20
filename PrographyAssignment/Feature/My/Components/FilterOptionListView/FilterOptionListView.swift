//
//  FilterOptionListView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/20/25.
//

import UIKit

import RxSwift
import SnapKit

final class FilterOptionListView: UIView {
    
    // MARK: Components
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.isLayoutMarginsRelativeArrangement = true
        sv.directionalLayoutMargins = .init(edges: 8)
        sv.layer.borderColor = UIColor.brandColor.cgColor
        sv.layer.borderWidth = 1
        sv.layer.cornerRadius = 12
        sv.clipsToBounds = true
        return sv
    }()
    
    // All과 별 심볼들을 한 배열에 담기 (UIButton으로 업캐스팅)
    fileprivate var symbolButtons: [UIButton] = {
        let label = UILabel()
        label.text = "All"
        label.textColor = .black
        label.font = .pretendardSemiBold16
        let allButton = SymbolButton(custom: label)
        
        let starsButtons = (0...5).reversed()
            .map { StarsView(rate: $0) }
            .map { SymbolButton(custom: $0) }

        return [allButton] + starsButtons
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
        self.addSubview(overallVStack)
        symbolButtons.forEach { overallVStack.addArrangedSubview($0) }
        
        overallVStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        symbolButtons.forEach { $0.snp.makeConstraints { $0.height.equalTo(40) } }
    }
}

#Preview(traits: .fixedLayout(width: 380, height: 296)) {
    FilterOptionListView()
}

// MARK: - Reactive

extension Reactive where Base: FilterOptionListView {
    // 6개의 버튼 배열의 탭 이벤트를 하나로 묶고, 인덱스로 변환
    var tap: Observable<Int> {
        let buttonTaps = base.symbolButtons
            .reversed()
            .enumerated()
            .map { i, btn in btn.rx.tap.map { _ in i } }
        
        return Observable.merge(buttonTaps)
    }
}
