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
    
    private let overallVStack = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let posterCardView = PosterCardView()
    
    private let starLineView = StarLineView()
    
    private let detailsView = DetailsView()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
        setAutoLayout()
        setBinding()
    }
    
    // MARK: Layout
    
    private func setAutoLayout() {
        view.addSubview(overallVStack)
        overallVStack.addArrangedSubview(posterCardView)
        overallVStack.addArrangedSubview(starLineView)
        overallVStack.addArrangedSubview(detailsView)
        
        overallVStack.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        posterCardView.snp.makeConstraints { $0.height.equalTo(247) }
        starLineView.snp.makeConstraints { $0.height.equalTo(60) }
    }

    // MARK: Binding
    
    private func setBinding() {
        guard let movieReviewVM else { return }
        
        let input = MovieReviewVM.Input()
        let output = movieReviewVM.transform(input: input)
        
        output.movieDetails
            .bind(to: posterCardView.rx.movieDetails, detailsView.rx.movieDetails)
            .disposed(by: bag)
        
        output.rate
            .bind(to: starLineView.rx.rate)
            .disposed(by: bag)
    }
}

#Preview {
    let vc = MovieReviewVC()
//    vc.movieReviewVM = MovieReviewVM(822119)
    return UINavigationController(rootViewController: vc)
}
