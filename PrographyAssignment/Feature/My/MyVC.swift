//
//  MyVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class MyVC: UIViewController {
    
    typealias RxDataSource = RxCollectionViewSectionedAnimatedDataSource
    
    // MARK: Properties
    
    private let myVM = MyVM()
    private let bag = DisposeBag()
    private let once = OnlyOnce()
    
    // MARK: Interface
    
    private let viewWillAppearEvent = PublishSubject<Void>()

    // MARK: Components

    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let filterOptionButton = FilterOptionButton()
    
    private let filterOptionListView = FilterOptionListView()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearEvent.onNext(())
    }

    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        view.addSubview(filterOptionListView)
        overallVStack.addArrangedSubview(filterOptionButton)
        overallVStack.addArrangedSubview(reviewedMovieCV)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        filterOptionButton.snp.makeConstraints { $0.height.equalTo(96) }
        filterOptionListView.snp.makeConstraints {
            $0.top.equalTo(filterOptionButton.snp.bottom).offset(-16)
            $0.horizontalEdges.equalToSuperview()
        }
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
        let input = MyVM.Input(
            modelSelected: reviewedMovieCV.rx.modelSelected(MovieId.self).asObservable(),
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            filterOptionButtonTap: filterOptionButton.rx.tap,
            selectedOption: filterOptionListView.rx.selectedOption
        )
        let output = myVM.transform(input)
        
        // 리뷰한 영화 셀 데이터 바인딩
        output.reviewedMovieSectionArr
            .bind(to: reviewedMovieCV.rx.items(dataSource: getReviewedMovieCellDataSource()))
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        output.pushMovieReview
            .bind(to: self.rx.pushMovieReview)
            .disposed(by: bag)
        
        output.optionListAppearance
            .bind(to: filterOptionListView.rx.isHidden)
            .disposed(by: bag)
        
        output.selectedOption
            .bind(to: filterOptionButton.rx.optionSelected)
            .disposed(by: bag)
    }
    
    // MARK: Rx Data Sources
    
    private func getReviewedMovieCellDataSource() -> RxDataSource<ReviewedMovieSection> {
        let animeConfig = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .fade
        )
        
        return RxDataSource<ReviewedMovieSection>(
            animationConfiguration: animeConfig
        ) { _, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReviewedMovieCell.identifier,
                for: indexPath
            ) as? ReviewedMovieCell
            else { return UICollectionViewCell() }
            cell.configure(item)
            return cell
        }
    }
}

#Preview {
    UINavigationController(rootViewController: MyVC())
}

// MARK: - Reactive

extension Reactive where Base: MyVC {
    var pushMovieReview: Binder<Int> {
        Binder(base) {
            let vc = MovieReviewVC()
            vc.movieReviewVM = .init($1)
            vc.hidesBottomBarWhenPushed = true
            $0.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
