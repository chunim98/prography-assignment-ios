//
//  PageTableVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

final class PageTableVC: UIPageViewController {
    
    private var pages = [UIViewController]()
    private let view1 = {
        let view = UIViewController()
        view.view.backgroundColor = .green
        return view
    }()
    private let view2 = {
        let view = UIViewController()
        view.view.backgroundColor = .red
        return view
    }()
    private let view3 = {
        let view = UIViewController()
        view.view.backgroundColor = .blue
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [view1, view2, view3]
        self.dataSource = self
        self.setViewControllers([pages[0]], direction: .forward, animated: true)
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
    PageTableVC(transitionStyle: .scroll, navigationOrientation: .horizontal)
}
