//
//  StarButtonsView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class StarButtonsView: UIView {
    
    // MARK: Components
    
    private let overallHStack = UIStackView()
    
    fileprivate let buttons: [UIButton] = {
        Array(0..<5).map { _ in
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named: "star")?
                .withTintColor(UIColor(hex: 0xB1B1B1))
                .resizeImage(newWidth: 40)
            return UIButton(configuration: config)
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
        buttons.forEach { overallHStack.addArrangedSubview($0) }
        
        overallHStack.snp.makeConstraints { $0.centerX.verticalEdges.equalToSuperview() }
        buttons.forEach { $0.snp.makeConstraints { $0.size.equalTo(40) } }
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 60)) {
    StarButtonsView()
}

// MARK: - Reactive

extension Reactive where Base: StarButtonsView {
    
    // 외부에서 받아온 점수를 바탕으로 별 버튼의 색을 채워넣기
    var rate: Binder<ReviewData> {
        Binder(base) { base, data in
            base.buttons.enumerated().forEach { index, button in
                let isSelected = (index+1 <= data.personalRate)
                let color = isSelected ? .brandColor : UIColor(hex: 0xB1B1B1)
                button.configuration?.image = button.configuration?.image?.withTintColor(color)
            }
        }
    }
    
    // 5개의 버튼 배열의 탭 이벤트를 하나로 묶고, 인덱스로 변환 (점수를 보내는 게 아님)
    var tap: Observable<Int> {
        Observable.merge(base.buttons.enumerated().map { index, button in
            button.rx.tap.map { _ in index }
        })
    }
}
