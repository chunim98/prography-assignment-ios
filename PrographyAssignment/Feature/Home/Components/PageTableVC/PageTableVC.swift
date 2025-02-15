//
//  PageTableVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

final class PageTableVC: UIPageViewController {

    // MARK: Properties

    private var pages = [UIViewController]()

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
        self.setViewControllers([nowPlayingVC], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
