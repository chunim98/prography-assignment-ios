//
//  DetailView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class DetailView: UIView {
    
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
        label.textColor = .black
        label.font = .pretendardBold45
        return label
    }()
    
    fileprivate let rateLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .pretendardBold16
        return label
    }()
    
    fileprivate let genreCV = {
        let cv = GenreTagCollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        cv.setSinglelineLayout(spacing: 4, itemSize: CGSize(width: 40, height: 16))
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let overviewTextView = {
        let tv = UITextView()
        tv.textContainer.lineFragmentPadding = 0 // 좌우 여백 제거
        tv.textContainerInset = .zero // 상하 여백 제거
        tv.font = .pretendardMedium16
        tv.textColor = .black.withAlphaComponent(0.8)
        tv.isEditable = false
        tv.isSelectable = false
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
    DetailView()
}

// MARK: - Reactive

extension Reactive where Base: DetailView {
    var movieDetail: Binder<MovieDetail> {
        Binder(base) { base, detail in
            base.titleLabel.text = detail.title
            base.rateLabel.text = String(format: "/ %.1f", detail.voteAverage)
            base.overviewTextView.text = detail.overview
            
            let genreIds = detail.genres.map { $0.id }
            
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
