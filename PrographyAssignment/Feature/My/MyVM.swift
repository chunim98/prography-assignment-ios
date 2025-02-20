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
        let filterOptionButtonTap: Observable<Void>
        let selectedOption: Observable<Int>
    }
    
    struct Output {
        let reviewedMovieCellDataArr: Observable<[ReviewedMovieCellData]>
        let pushMovieReview: Observable<Int>
        let optionListAppearance: Observable<Bool>
        let selectedOption: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let reviewedMovieCellDataArr_ = BehaviorSubject(value: fetchReviewedMovieCellDataArr())
        let optionListAppearance = BehaviorSubject(value: true)
        let selectedOption = BehaviorSubject(value: 6) // All
        
        // 화면이 표시될 때마다 리스트 정보 갱신
        input.viewWillAppearEvent
            .compactMap { [weak self] _ in self?.fetchReviewedMovieCellDataArr() }
            .bind(to: reviewedMovieCellDataArr_)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        let pushMovieReview = input.modelSelected
            .map { $0.id }
        
        // 옵션 버튼을 탭하면 옵션 리스트를 표시
        input.filterOptionButtonTap
            .withLatestFrom(optionListAppearance) { _, bool in !bool }
            .bind(to: optionListAppearance)
            .disposed(by: bag)
        
        // 선택된 조건에 따라, 옵션 버튼의 상태 업데이트
        input.selectedOption
            .bind(to: selectedOption)
            .disposed(by: bag)
            
        // 조건을 선택하면 리스트 창 닫기
        input.selectedOption
            .withLatestFrom(optionListAppearance) { _, bool in !bool }
            .bind(to: optionListAppearance)
            .disposed(by: bag)

        // 조건에 맞는 리스트를 내보내기 (6의 경우 All)
        let reviewedMovieCellDataArr = Observable
            .combineLatest(reviewedMovieCellDataArr_, selectedOption) { dataArr, index in
                index == 6 ? dataArr : dataArr.filter { $0.personalRate == index }
            }
            
        
        return Output(
            reviewedMovieCellDataArr: reviewedMovieCellDataArr,
            pushMovieReview: pushMovieReview,
            optionListAppearance: optionListAppearance.asObservable(),
            selectedOption: selectedOption
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
