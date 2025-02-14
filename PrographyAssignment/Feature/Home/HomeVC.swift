//
//  HomeVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class HomeVC: UIViewController {
    
    // MARK: Properties
    
    private let homeVM = HomeVM()
    private let bag = DisposeBag()
    
    // MARK: Components
    
    private let backdropCarouselView = BackdropCarouselView()
    private let tabContentsView = TabContentsView()
        
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
        
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(backdropCarouselView)
        view.addSubview(tabContentsView)
        
        backdropCarouselView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(221)
        }
        tabContentsView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let input = HomeVM.Input()
        
        let output = homeVM.transform(input: input)
        
        output.nowPlaying
            .bind(to: backdropCarouselView.nowPlayingInput)
            .disposed(by: bag)
    }

}

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
