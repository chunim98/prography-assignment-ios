//
//  ListCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import Kingfisher
import RxSwift
import RxCocoa
import SnapKit

final class ListCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "ListCell"
    private var bag = DisposeBag()
        
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
        label.text = "대충 두 줄까지만\n보여야 한다고 함\n밥 뭐 먹지" // temp
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
    
    private let genreCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        cv.setSinglelineLayout(spacing: 4, itemSize: CGSize(width: 40, height: 16))
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    // MARK: Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setAutoLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        rateLabel.text = nil
        bag = DisposeBag() // rx 바인딩 초기화
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
        contentVStack.addArrangedSubview(genreCV)
        
        overallHStack.snp.makeConstraints {
            let inset = UIEdgeInsets(left: 16, bottom: 16, right: 16)
            $0.edges.equalToSuperview().inset(inset)
        }
        posterImageView.snp.makeConstraints { $0.width.equalTo(120) }
        genreCV.snp.makeConstraints { $0.height.equalTo(16) }
    }
    
    // MARK: Configure Components
    
    func configure(_ item: ListCellData) {
        let url = URL(string: item.posterPath)
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: url)

        titleLabel.text = item.title
        overviewLabel.text = item.overview
        rateLabel.text = String(format: "★ %.1f", item.voteAverage)
        
        // 장르 컬렉션 뷰 데이터 바인딩 (따로 바인딩 메서드는 안만드는 게 나은 듯)
        Observable.just(item.genreIDS)
            .bind(to: genreCV.rx.items(
                cellIdentifier: GenreCell.identifier,cellType: GenreCell.self
            )) { index, item, cell in
                cell.configure(item)
            }
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 380, height: 160+16)) {
    ListCell()
}
