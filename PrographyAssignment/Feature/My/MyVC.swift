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
    
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource
    
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
    
    fileprivate let filterButton = FilterButton()
    
    fileprivate let filterListView = FilterListView()
    
    fileprivate let myMovieCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: .init())
        cv.register(
            MyMovieCell.self,
            forCellWithReuseIdentifier: MyMovieCell.identifier
        )
        return cv
    }()
    
    fileprivate let cvBackView = {
        let label = UILabel()
        label.text = "작성한 리뷰가 없는 것 같아요."
        label.textColor = .lightGray
        label.font = .pretendardBold22
        label.textAlignment = .center
        return label
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
        view.addSubview(filterListView)
        overallVStack.addArrangedSubview(filterButton)
        overallVStack.addArrangedSubview(myMovieCV)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        filterButton.snp.makeConstraints { $0.height.equalTo(96) }
        filterListView.snp.makeConstraints {
            $0.top.equalTo(filterButton.snp.bottom).offset(-16)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setFlowLayout() {
        view.layoutIfNeeded()
        myMovieCV.setMultilineLayout(
            spacing: 8,
            itemCount: 3,
            itemSize: CGSize(width: 121.3, height: 240),
            sectionInset: UIEdgeInsets(horizontal: 16) + UIEdgeInsets(bottom: 32)
        )
    }

    // MARK: Binding
    
    private func setBinding() {
        let input = MyVM.Input(
            selectedModel: myMovieCV.rx.modelSelected(MovieId.self).asObservable(),
            viewWillAppearEvent: viewWillAppearEvent.asObservable(),
            filterButtonTapEvent: filterButton.rx.tapEvent,
            selectedFilterIndex: filterListView.rx.selectedFilterIndex
        )
        let output = myVM.transform(input)
        
        // 리뷰한 영화 셀 데이터 바인딩
        output.myMovieSectionDataArr
            .bind(to: myMovieCV.rx.items(dataSource: getMyMovieDataSource()))
            .disposed(by: bag)
        
        // 보여줄 리뷰가 없다면 백그라운드 표시
        output.isCVBackViewHidden
            .bind(to: self.rx.isCVBackViewHidden)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        output.movieId
            .bind(to: self.rx.pushMovieReviewBinder)
            .disposed(by: bag)
        
        // 필터 리스트의 숨김,표시 상태 바인딩
        output.isFilterListHidden
            .bind(to: filterListView.rx.isHiddenWithAnime)
            .disposed(by: bag)
        
        // 선택한 필터에 따라, 필터 버튼의 심볼 이미지 갱신
        output.selectedFilterIndex
            .bind(to: filterButton.rx.selectedFilterIndex)
            .disposed(by: bag)
    }
    
    // MARK: Rx Data Sources
    
    private func getMyMovieDataSource() -> DataSource<MyMovieSectionData> {
        let animeConfig = AnimationConfiguration(
            insertAnimation: .fade,
            reloadAnimation: .fade,
            deleteAnimation: .fade
        )
        
        return DataSource<MyMovieSectionData>(
            animationConfiguration: animeConfig
        ) { _, collectionView, indexPath, data in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyMovieCell.identifier,
                for: indexPath
            ) as? MyMovieCell
            else { return UICollectionViewCell() }
            cell.configure(data)
            return cell
        }
    }
}

#Preview {
    UINavigationController(rootViewController: MyVC())
}

// MARK: - Reactive

extension Reactive where Base: MyVC {
    
    fileprivate var isCVBackViewHidden: Binder<Bool> {
        Binder(base) { $0.myMovieCV.backgroundView = $1 ? nil : $0.cvBackView }
    }
    
    fileprivate var pushMovieReviewBinder: Binder<Int> {
        Binder(base) {
            let vc = MovieReviewVC()
            vc.movieReviewVM = .init($1)
            vc.hidesBottomBarWhenPushed = true
            $0.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
