//
//  SymbolButton.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/20/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class SymbolButton: UIButton {
    
    // MARK: Properties
    
    private let bag = DisposeBag()
    
    // MARK: Components
    
    private let symbolContainer = {
        let sv = UIStackView()
        sv.isUserInteractionEnabled = false
        return sv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 속성 초기화
        self.configuration = .plain()
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        setLayout()
        setBinding()
    }
    
    convenience init(custom: UIView) {
        self.init(frame: .zero)
        symbolContainer.addArrangedSubview(custom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setLayout() {
        self.addSubview(symbolContainer)
        symbolContainer.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(UIEdgeInsets(vertical: 12))
            $0.leading.equalToSuperview().inset(8)
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        // 버튼이 하이라이트 됐을 때 반투명 효과를 주기
        self.rx.methodInvoked(#selector(setter: self.isHighlighted))
            .compactMap { $0.first as? Bool }
            .distinctUntilChanged()
            .bind(with: self) { $0.backgroundColor = $1 ? UIColor(hex: 0xF2F2F7) : .white }
            .disposed(by: bag)
    }
}

#Preview(traits: .defaultLayout) {
    SymbolButton(custom: StarsView(rate: 3))
}
