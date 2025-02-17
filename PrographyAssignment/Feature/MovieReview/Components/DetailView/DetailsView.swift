//
//  DetailsView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class DetailsView: UIView {
    
    // MARK: Properties
    
    fileprivate let bag = DisposeBag()
    
    // MARK: Components
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    private let titleHStack = {
        let sv = UIStackView()
        sv.alignment = .bottom
        sv.spacing = 8
        return sv
    }()
    
    fileprivate let titleLabel = {
        let label = UILabel()
        label.text = "Title" // temp
        label.textColor = .black
        label.font = .pretendardBold45
        label.backgroundColor = .gray // temp
        return label
    }()
    
    fileprivate let rateLabel = {
        let label = UILabel()
        label.text = "/ rate" // temp
        label.textColor = .black
        label.font = .pretendardBold16
        label.backgroundColor = .gray // temp
        return label
    }()
    
    fileprivate let genreCV = {
        let cv = GenreTagCollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        cv.setSinglelineLayout(spacing: 4, itemSize: CGSize(width: 40, height: 16))
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .gray // temp
        return cv
    }()
    
    fileprivate let overviewTextView = {
        let tv = UITextView()
        tv.text = "너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 어쩌구 저쩌구.."
        tv.font = .pretendardMedium16
        tv.textColor = .black.withAlphaComponent(0.8)
        tv.isEditable = false
        tv.isSelectable = false
        tv.backgroundColor = .gray // temp
        return tv
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
        self.addSubview(overallVStack)
        overallVStack.addArrangedSubview(titleHStack)
        overallVStack.addArrangedSubview(genreCV)
        overallVStack.addArrangedSubview(overviewTextView)
        titleHStack.addArrangedSubview(titleLabel)
        titleHStack.addArrangedSubview(rateLabel)
        
        rateLabel.setContentCompressionResistancePriority(.init(999), for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(999), for: .horizontal)
        
        overallVStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16); $0.width.equalTo(400) }
        titleHStack.snp.makeConstraints { $0.height.equalTo(44) }
        genreCV.snp.makeConstraints { $0.height.equalTo(16) }
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 294)) {
    DetailsView()
}

// MARK: - Reactive

extension Reactive where Base: DetailsView {
    var movieDetails: Binder<MovieDetails> {
        Binder(base) { base, details in
            base.titleLabel.text = details.title
            base.rateLabel.text = String(format: "/ %.1f", details.voteAverage)
            
            let genreIds = details.genres.map { $0.id }
            
            Observable.just(genreIds)
                .bind(to: base.genreCV.rx.items(
                    cellIdentifier: GenreCell.identifier,cellType: GenreCell.self
                )) { index, item, cell in
                    cell.configure(item)
                }
                .disposed(by: base.bag)
            
            // 데이터 바인딩 끝나고, 폰트 길이에 맞게 레이아웃 재계산
            base.genreCV.genreIds = genreIds
            base.genreCV.collectionViewLayout.invalidateLayout()
        }
    }
}
