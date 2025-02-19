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
    
    private let bag = DisposeBag()

    // MARK: Components

    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let filterOptionButton = FilterOptionButton()
    
    private let reviewedMovieCV = {
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
//        cv.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
//        cv.setSinglelineLayout(spacing: 8, itemSize: CGSize(width: 316, height: 205))
//        cv.showsHorizontalScrollIndicator = false
//        return cv
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
        setAutoLayout()
    }

    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        overallVStack.addArrangedSubview(filterOptionButton)
        overallVStack.addArrangedSubview(UIView()) // temp
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        filterOptionButton.snp.makeConstraints { $0.height.equalTo(96) }
    }

    // MARK: Binding
}

#Preview {
    UINavigationController(rootViewController: MyVC())
}
