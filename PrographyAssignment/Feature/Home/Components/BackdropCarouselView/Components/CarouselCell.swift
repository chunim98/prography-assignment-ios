//
//  CarouselCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import Kingfisher
import SnapKit

final class CarouselCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "CarouselCell"
    
    // MARK: Components
    
    private let backImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let gradientView = CarouselGradientView()
    
    private let labelVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .pretendardBold16
        label.textColor = .white
        return label
    }()
    
    private let overviewLabel = {
        let label = UILabel()
        label.font = .pretendardSemiBold11
        label.textColor = .white
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 콘텐츠 뷰 구성
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 28
        contentView.clipsToBounds = true
        
        setAutoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(backImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(labelVStack)
        labelVStack.addArrangedSubview(UIView())
        labelVStack.addArrangedSubview(titleLabel)
        labelVStack.addArrangedSubview(overviewLabel)
        
        backImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        gradientView.snp.makeConstraints { $0.edges.equalToSuperview() }
        labelVStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
    }
    
    // MARK: Configure Components
    
    func configure(_ data: CarouselCellData) {
        let url = URL(string: data.backDropPath)
        backImageView.kf.indicatorType = .activity
        backImageView.kf.setImage(with: url)
        
        titleLabel.text = data.title
        overviewLabel.text = data.overview
    }
}

#Preview(traits: .fixedLayout(width: 316, height: 205)) {
    CarouselCell()
}
