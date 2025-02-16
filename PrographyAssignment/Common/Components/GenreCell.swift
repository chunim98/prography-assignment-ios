//
//  GenreCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import SnapKit

final class GenreCell: UICollectionViewCell {
    
    // MARK: Properties
    
    static let identifier = "GenreCell"
    
    // MARK: Components
    
    private let genreLabel = {
        let label = UILabel()
        label.text = "Genre" // temp
        label.font = .pretendardSemiBold11
        label.textColor = .onSurfaceVariant
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // contentView 구성
        contentView.layer.borderColor = UIColor.brandColor.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        // 레이아웃
        setAutoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        contentView.addSubview(genreLabel)
        genreLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // MARK: Configure Components
    
    func configure(_ id: Int) {
        genreLabel.text = id.genreName
    }
}

#Preview(traits: .fixedLayout(width: 40, height: 16)) {
    GenreCell()
}
