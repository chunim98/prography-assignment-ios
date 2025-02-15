//
//  BackdropCarouselView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class BackdropCarouselView: UIView {
    
    // MARK: Properties
    
    private let backdropCarouselVM = BackdropCarouselVM()
    private let bag = DisposeBag()
    
    // MARK: Dependency Input
    
    let nowPlayingInput = PublishSubject<MovieInfo>()
    
    // MARK: Components
    
    private let carouselCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        cv.setSinglelineLayout(spacing: 8, itemSize: CGSize(width: 316, height: 205))
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAutoLayout()
        setBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        self.addSubview(carouselCV)
        
        carouselCV.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 16, vertical: 8))
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = BackdropCarouselVM.Input(nowPlaying: nowPlayingInput.asObservable())
        
        let output = backdropCarouselVM.transform(input: input)
        
        // 캐러셀 컬렉션 뷰 데이터 바인딩
        output.carouselCellDataArr
            .bind(to: carouselCV.rx.items(
                cellIdentifier: CarouselCell.identifier,
                cellType: CarouselCell.self
            )) { index, item, cell in
                cell.configure(item)
            }
            .disposed(by: bag)
    }
}

#Preview(traits: .fixedLayout(width: 412, height: 221)) {
    BackdropCarouselView()
}
