//
//  MovieReviewVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MovieReviewVC: UIViewController {
    
    // MARK: Properties
    
    var movieReviewVM: MovieReviewVM?
    private let bag = DisposeBag()
    
    // MARK: Components
    
    private let backBarButton = BackBarButton()
    
    fileprivate let pullDownBarButton = PullDownBarButton()
    
    fileprivate let saveBarButton = SaveBarButton()
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let posterCardView = PosterCardView()
    
    private let starButtonsView = StarButtonsView()
    
    private let detailsView = DetailsView()
    
    private let commentView = CommentView()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBar(
            leftBarButtonItems: [backBarButton],
            rightBarButtonItems: [pullDownBarButton],
            titleImage: UIImage(named: "prography_logo")
        )
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        overallVStack.addArrangedSubview(posterCardView)
        overallVStack.addArrangedSubview(starButtonsView)
        overallVStack.addArrangedSubview(detailsView)
        overallVStack.addArrangedSubview(commentView)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        posterCardView.snp.makeConstraints { $0.height.equalTo(247) }
        starButtonsView.snp.makeConstraints { $0.height.equalTo(60) }
    }

    // MARK: Binding
    
    private func setBinding() {
        guard let movieReviewVM else { return }
        
        let barButtonEvent = Observable
            .merge(backBarButton.rx.event, pullDownBarButton.rx.event, saveBarButton.rx.event)
        
        let input = MovieReviewVM.Input(
            starButtonsTap: starButtonsView.rx.tap,
            updatedText: commentView.rx.updatedText,
            barButtonEvent: barButtonEvent
        )
        let output = movieReviewVM.transform(input: input)
        
        // 영화 세부정보 데이터 바인딩
        output.movieDetails
            .bind(to: posterCardView.rx.movieDetails, detailsView.rx.movieDetails)
            .disposed(by: bag)
        
        // 리뷰 데이터 바인딩
        output.reviewData
            .bind(to: starButtonsView.rx.rate, commentView.rx.text)
            .disposed(by: bag)
        
        // 리뷰 상태 바인딩
        output.state
            .bind(to: commentView.rx.state, self.rx.barButtons)
            .disposed(by: bag)
        
        output.dismissEvent
            .bind(to: self.rx.dismiss)
            .disposed(by: bag)
    }
}

#Preview {
    let vc = MovieReviewVC()
    vc.movieReviewVM = MovieReviewVM(822119)
    return UINavigationController(rootViewController: vc)
}

// MARK: - Reactive

extension Reactive where Base: MovieReviewVC {
    var barButtons: Binder<ReviewState> {
        Binder(base) {
            $0.navigationItem.rightBarButtonItem = [.create, .edit].contains($1)
            ? $0.saveBarButton : $0.pullDownBarButton
        }
    }
    
    var dismiss: Binder<Void> {
        Binder(base) { base, _ in
            base.navigationController?.popViewController(animated: true)
        }
    }
}
