//
//  PageTableVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class PageTableVC: UIPageViewController {
    
    // MARK: Dependency Input
    
    let nowPlayingInput = PublishSubject<MovieInfo>()

    // MARK: Dependency Output
    
    
    // MARK: Properties
    
    private let pageTableVM = PageTableVM()
    private let bag = DisposeBag()

    // MARK: Components
    
    private var pages = [UIViewController]()
    private let view1 = MovieListVC()
    private let view2 = TestVC()
    private let view3 = {
        let view = UIViewController()
        view.view.backgroundColor = .blue
        return view
    }()
    
    // MARK: Life Cycle
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        
        pages = [view1, view2, view3]
        self.dataSource = self
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = PageTableVM.Input(
            nowPlaying: nowPlayingInput.asObservable()
        )
        
        let output = pageTableVM.transform(input: input)
        
        // nowPlaying 페이지와 데이터 바인딩
        output.nowPlayingListCellDataArr
            .bind(to: view1.listCellDataArrInput)
            .disposed(by: bag)
    }
}

extension PageTableVC: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex > 0
        else { return nil }
        
        return pages[currentIndex - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex < (pages.count - 1)
        else { return nil }
        
        return pages[currentIndex + 1]
    }
    
    
}

#Preview {
    PageTableVC()
}
