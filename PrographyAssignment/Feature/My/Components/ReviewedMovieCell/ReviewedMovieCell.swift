//
//  ReviewedMovieCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift
import SnapKit

final class ReviewedMovieCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "ReviewedMovieCell"
    
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
        return iv
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "제목입니다" // temp
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
    }
}

#Preview(traits: .fixedLayout(width: 120, height: 240)) {
    ReviewedMovieCell()
}

// MARK: - Reactive

extension Reactive where Base: ReviewedMovieCell {
    // 점수에 맞게 색 채우기
//    var rate: Binder<Int> {
//        Binder(base) { base, rate in
//            base.imageViews.enumerated().forEach { index, imageView in
//                let isSelected = (index+1 <= rate)
//                let color = isSelected ? .brandColor : UIColor(hex: 0xB1B1B1)
//                imageView.image = imageView.image?.withTintColor(color)
//            }
//        }
//    }
}
