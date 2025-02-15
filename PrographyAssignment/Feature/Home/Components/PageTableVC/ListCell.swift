//
//  ListCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ListCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "ListCell"
    
    // MARK: Components
    
    private let overallHStack = {
        let sv = UIStackView()
        sv.spacing = 16
        return sv
    }()
    
    private let posterImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "prography_logo") // temp
        iv.backgroundColor = .gray // temp
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    // contentVStack을 중앙으로 배치하는 목적
    private let contentContainer = {
        let sv = UIStackView()
        sv.alignment = .center
        return sv
    }()
    
    private let contentVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "Title" // temp
        label.font = .pretendardBold22
        label.textColor = .onSurface
        return label
    }()
    
    private let overviewLabel = {
        let label = UILabel()
        label.text = "대충 두 줄까지만 보여야 한다고 함\n밥 뭐 먹지" // temp
        label.font = .pretendardMedium16
        label.textColor = .onSurfaceVariant
        label.numberOfLines = 2
        return label
    }()
    
    private let rateLabel = {
        let label = UILabel()
        label.text = "rate" // temp
        label.font = .pretendardSemiBold14
        label.textColor = .onSurfaceVariant
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(overallHStack)
        overallHStack.addArrangedSubview(posterImageView)
        overallHStack.addArrangedSubview(contentContainer)
        contentContainer.addArrangedSubview(contentVStack)
        contentVStack.addArrangedSubview(titleLabel)
        contentVStack.addArrangedSubview(overviewLabel)
        contentVStack.addArrangedSubview(rateLabel)
        
        overallHStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        posterImageView.snp.makeConstraints { $0.width.equalTo(120) }
    }
}

#Preview(traits: .fixedLayout(width: 380, height: 160)) {
    ListCell()
}
