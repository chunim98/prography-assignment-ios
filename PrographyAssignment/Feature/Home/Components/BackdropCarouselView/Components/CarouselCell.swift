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
    static let identifier = "CarouselCell"
    
    // MARK: Components
    
    let backImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "prography_logo")
        return imageView
    }()
    
    let gradientView = CarouselGradientView()
    
    let labelVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    let titleLabel = {
        let label = UILabel()
        label.text = "Title" // temp
        label.font = .pretendardBold16
        label.textColor = .white
        return label
    }()
    
    let overViewLabel = {
        let label = UILabel()
        label.text = "대충 한 줄이 넘지 않게 구현해야 한다고 함" // temp
        label.font = .pretendardSemiBold11
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 콘텐츠 뷰 구성
        contentView.backgroundColor = .gray
        contentView.layer.cornerRadius = 28
        contentView.clipsToBounds = true
        
        setAutoLayout()
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
        labelVStack.addArrangedSubview(overViewLabel)
        
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
        overViewLabel.text = data.overview
//                let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500/5ZoI48Puf5i5FwI6HOpunDuJOw0.jpg")!)
//                backImageView.image = UIImage(data: data!)
    }
}

#Preview(traits: .fixedLayout(width: 316, height: 205)) {
    CarouselCell()
}
