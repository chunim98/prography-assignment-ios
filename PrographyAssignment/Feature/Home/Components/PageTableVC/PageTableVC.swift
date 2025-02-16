//
//  PageTableVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift

final class PageTableVC: UIPageViewController {

    // MARK: Properties

    fileprivate var pages = [UIViewController]()
    fileprivate var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }

    // MARK: Interface
    
    fileprivate let selectedIndexIn = PublishSubject<Int>()
    fileprivate let changeIndexOut = PublishSubject<Int>()

    // MARK: Components
    
    private let nowPlayingVC = MovieListVC(.nowPlaying)
    private let popularVC = MovieListVC(.popular)
    private let topRatedVC = MovieListVC(.topRated)
    
    // MARK: Life Cycle
    
    init() { super.init(transitionStyle: .scroll, navigationOrientation: .horizontal) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = [nowPlayingVC, popularVC, topRatedVC]
        self.dataSource = self
        self.delegate = self
        // 디버깅 할 때는 주석 풀기
        // self.setViewControllers([nowPlayingVC], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageTableVC: UIPageViewControllerDelegate {
    // 사용자가 스와이프해서 페이지를 변경할 때만 실행됨(살았다..)
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        changeIndexOut.onNext(currentIndex)
    }
}

extension PageTableVC: UIPageViewControllerDataSource {
    // 좌우 스와이프 할 때 어떤 페이지를 보여줄지에 관한 메서드
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex > 0
        else { return nil }
        
        return pages[currentIndex-1]
    }
    
    // 좌우 스와이프 할 때 어떤 페이지를 보여줄지에 관한 메서드
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let currentIndex = pages.firstIndex(of: viewController),
            currentIndex < (pages.count-1)
        else { return nil }
        
        return pages[currentIndex+1]
    }
}

#Preview {
    PageTableVC()
}

// MARK: - Reactive

extension Reactive where Base: PageTableVC {
    var seletedIndex: Binder<Int> {
        Binder(base) { base, index in
            // 타입 이름이 길어서 앨리어스 설정
            typealias Direction = UIPageViewController.NavigationDirection
            // 이전 페이지 인덱스에 따라 전환 애니메이션 방향을 다르게 설정
            let direction: Direction = base.currentIndex < index ? .forward : .reverse
            
            base.setViewControllers([base.pages[index]], direction: direction, animated: true)
        }
    }
    
    var changeIndex: Observable<Int> {
        base.changeIndexOut.asObservable()
    }
}
