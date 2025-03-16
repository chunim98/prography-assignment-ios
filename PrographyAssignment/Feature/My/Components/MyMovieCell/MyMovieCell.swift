//
//  MyMovieCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import Kingfisher
import SnapKit

final class MyMovieCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "MyMovieCell"
    
    // MARK: Components
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    private let titleVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        return sv
    }()
    
    private let posterImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .onSurface
        label.font = .pretendardSemiBold14
        return label
    }()
    
    private let starsView = StarsView()

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
        contentView.addSubview(overallVStack)
        overallVStack.addArrangedSubview(posterImageView)
        overallVStack.addArrangedSubview(titleVStack)
        titleVStack.addArrangedSubview(titleLabel)
        titleVStack.addArrangedSubview(starsView)
        
        overallVStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(vertical: 8))
        }
        titleVStack.snp.makeConstraints { $0.height.equalTo(36) }
    }
    
    // MARK: Configure Components

    func configure(_ data: MyMovieCellData) {
        if let posterPath = data.posterPath {
            let url = URL(string: posterPath)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url)
        }

        titleLabel.text = data.title
        starsView.rx.rate.onNext(data.personalRate)
    }
}

#Preview(traits: .fixedLayout(width: 120, height: 240)) {
    MyMovieCell()
}
