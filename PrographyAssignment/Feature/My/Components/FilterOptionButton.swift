//
//  FilterOptionButton.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class FilterOptionButton: UIView {
    
    // MARK: Components
    
    private let button = {
        let button = UIButton(configuration: .plain())
        button.layer.borderColor = UIColor.brandColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private let allLabel = {
        let label = UILabel()
        label.text = "All"
        label.textColor = .black
        label.font = .pretendardBold16
        return label
    }()
    
    private let listImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "list")?.resizeImage(newWidth: 24)
        iv.contentMode = .scaleAspectFit
        return iv
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
        self.addSubview(button)
        button.addSubview(allLabel)
        button.addSubview(listImageView)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.width.equalTo(380) // temp
            $0.height.equalTo(64) // temp
        }
        allLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview(); $0.leading.equalToSuperview().inset(16)
        }
        listImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview(); $0.trailing.equalToSuperview().inset(28)
        }
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 96)) {
    FilterOptionButton()
}
