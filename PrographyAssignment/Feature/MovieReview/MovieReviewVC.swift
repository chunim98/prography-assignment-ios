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
    
    private let tapGesture = UITapGestureRecognizer()
    
    private let backBarButton = BackBarButton()
    
    fileprivate let pullDownBarButton = PullDownBarButton()
    
    fileprivate let saveBarButton = SaveBarButton()
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let tapAreaVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let posterCardView = PosterCardView()
    
    private let starButtonsView = StarButtonsView()
    
    private let detailsView = DetailsView()
    
    fileprivate let commentView = CommentView()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tapAreaVStack.addGestureRecognizer(tapGesture)
        
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
        overallVStack.addArrangedSubview(tapAreaVStack)
        overallVStack.addArrangedSubview(commentView)
        tapAreaVStack.addArrangedSubview(posterCardView)
        tapAreaVStack.addArrangedSubview(starButtonsView)
        tapAreaVStack.addArrangedSubview(detailsView)
        
        overallVStack.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-10)
        }
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
            barButtonEvent: barButtonEvent,
            tapGestureEvent: tapGesture.rx.event.asObservable()
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
        
        // 화면 닫기
        output.dismissEvent
            .bind(to: self.rx.dismiss)
            .disposed(by: bag)
        
        // 키보드 닫기
        output.hideKeyBoardEvent
            .bind(to: self.rx.hideKeyBoardEvent)
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
    
    var hideKeyBoardEvent: Binder<Void> {
        Binder(base) { base, _ in base.commentView.endEditing(true) }
    }
}
