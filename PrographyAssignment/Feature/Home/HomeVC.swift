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
    
    fileprivate let panGesture = UIPanGestureRecognizer()
    
    fileprivate let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let headerContainer = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    fileprivate let backdropCarouselView = BackdropCarouselView()
    
    private let tabContentsView = TabContentsView()
    
    private let pageTableVC = PageTableVC()
        
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        headerContainer.addGestureRecognizer(panGesture)
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        overallVStack.addArrangedSubview(headerContainer)
        overallVStack.addArrangedSubview(pageTableVC.view)
        headerContainer.addArrangedSubview(backdropCarouselView)
        headerContainer.addArrangedSubview(tabContentsView)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        backdropCarouselView.snp.makeConstraints { $0.height.equalTo(221) }
        tabContentsView.snp.makeConstraints { $0.height.equalTo(80) }
    }
    
    // MARK: Binding
    
    private func setBinding() {
        let changeIndex = Observable.merge(
            tabContentsView.rx.changeIndex,
            pageTableVC.rx.changeIndex
        )
        let modelSelected = Observable.merge(
            backdropCarouselView.rx.modelSelected,
            pageTableVC.rx.modelSelected
        )
        
        let input = HomeVM.Input(
            changeIndex: changeIndex,
            panGestureEvent: panGesture.rx.event.asObservable(),
            modelSelected: modelSelected
        )
        let output = homeVM.transform(input: input)
        
        // 선택된 인덱스 상태 업데이트
        output.selectedIndex
            .bind(to: tabContentsView.rx.selectedIndex, pageTableVC.rx.seletedIndex)
            .disposed(by: bag)
        
        // 제스처에 따라 캐러셀 뷰 사이즈 조절
        output.panGestureEvent
            .bind(to: self.rx.carouselSizeAdjustment)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        output.pushMovieReview
            .bind(to: self.rx.pushMovieReview)
            .disposed(by: bag)
    }
}

#Preview {
    TabBarVC()
}

// MARK: Reactive

extension Reactive where Base: HomeVC {
    // 캐러셀 뷰 사이즈 조절 로직
    var carouselSizeAdjustment: Binder<UIPanGestureRecognizer> {
        Binder(base) { base, gesture in
            let changeY = gesture.translation(in: base.headerContainer).y // y축 움직이만 사용할 것임
            gesture.setTranslation(.zero, in: base.headerContainer) // 연속된 제스처라 호출마다 0으로 초기화
            // 캐러셀 뷰 높이 조정 (0...221 사이즈 안에서만 조정 가능하게 제한)
            let height = (base.backdropCarouselView.frame.height+changeY).clamped(0...221)
            
            base.backdropCarouselView.snp.updateConstraints { $0.height.equalTo(height) }
            base.headerContainer.layoutIfNeeded()
            
            // gesture가 끝났을 때 height 값에 따라 캐러셀 뷰 높이를 애니메이션 조정
            guard gesture.state == .ended else { return }
            
            let targetHeight = height < 110 ? 0 : 221
            UIView.animate(withDuration: 0.2) {
                base.backdropCarouselView.snp.updateConstraints { $0.height.equalTo(targetHeight) }
                base.overallVStack.layoutIfNeeded()
            }
        }
    }
    
    var pushMovieReview: Binder<Int> {
        Binder(base) {
            let vc = MovieReviewVC()
            vc.movieReviewVM = .init($1)
            vc.hidesBottomBarWhenPushed = true
            $0.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
