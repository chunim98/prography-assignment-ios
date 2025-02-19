//
//  MyVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/20/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MyVM {
    
    struct Input {
        let modelSelected: Observable<MovieId>
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let reviewedMovieCellDataArr: Observable<[ReviewedMovieCellData]>
        let pushMovieReview: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let reviewedMovieCellDataArr = BehaviorSubject(value: fetchReviewedMovieCellDataArr())
        
        // 화면이 표시될 때마다 리스트 정보 갱신
        input.viewWillAppearEvent
            .compactMap { [weak self] _ in self?.fetchReviewedMovieCellDataArr() }
            .bind(to: reviewedMovieCellDataArr)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        let pushMovieReview = input.modelSelected
            .map { $0.id }
        
        return Output(
            reviewedMovieCellDataArr: reviewedMovieCellDataArr.asObservable(),
            pushMovieReview: pushMovieReview
        )
    }
    
    // MARK: Methods
    
    private func fetchReviewedMovieCellDataArr() -> [ReviewedMovieCellData] {
        CoreDataManager.shared.readAll().map {
            ReviewedMovieCellData(
                id: $0.movieId,
                posterPath: $0.posterPath,
                personalRate: $0.personalRate,
                title: $0.title
            )
        }
    }
}
