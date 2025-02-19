//
//  MyVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MyVC: UIViewController {
    
    // MARK: Properties
    
    private let myVM = MyVM()
    private let bag = DisposeBag()
    private let once = OnlyOnce()

    // MARK: Components

    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let filterOptionButton = FilterOptionButton()
    
    private let reviewedMovieCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(
            ReviewedMovieCell.self,
            forCellWithReuseIdentifier: ReviewedMovieCell.identifier
        )
        return cv
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
        setAutoLayout()
        setBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        once.excute { setFlowLayout() }
    }

    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        overallVStack.addArrangedSubview(filterOptionButton)
        overallVStack.addArrangedSubview(reviewedMovieCV)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        filterOptionButton.snp.makeConstraints { $0.height.equalTo(96) }
    }
    
    private func setFlowLayout() {
        view.layoutIfNeeded()
        reviewedMovieCV.setMultilineLayout(
            spacing: 8,
            itemCount: 3,
            itemSize: CGSize(width: 121.3, height: 240),
            sectionInset: UIEdgeInsets(horizontal: 16) + UIEdgeInsets(bottom: 32)
        )
    }

    // MARK: Binding
    
    private func setBinding() {
        let input = MyVM.Input()
        let output = myVM.transform(input)
        
        // 리뷰한 영화 셀 데이터 바인딩
        output.reviewedMovieCellDataArr
            .bind(to: reviewedMovieCV.rx.items(
                cellIdentifier: ReviewedMovieCell.identifier,
                cellType: ReviewedMovieCell.self
            )) { index, item, cell in
                cell.configure(item)
            }
            .disposed(by: bag)
    }
}

#Preview {
    UINavigationController(rootViewController: MyVC())
}
