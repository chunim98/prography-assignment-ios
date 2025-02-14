//
//  HomeVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class HomeVC: UIViewController {
    private let homeVM = HomeVM()
    private let bag = DisposeBag()
    
    // MARK: Components
    
    let backdropCarouselView = BackdropCarouselView()
        
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
        
        backdropCarouselView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(221)
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
