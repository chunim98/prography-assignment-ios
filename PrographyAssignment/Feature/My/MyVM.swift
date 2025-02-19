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
    
    struct Input {}
    
    struct Output {
        let reviewedMovieCellDataArr: Observable<[ReviewedMovieCellData]>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let reviewedMovieCellDataArr = BehaviorSubject(value: fetchReviewedMovieCellDataArr())
        
        return Output(reviewedMovieCellDataArr: reviewedMovieCellDataArr.asObservable())
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
