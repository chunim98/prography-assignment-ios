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
        let filterButtonTapEvent: Observable<Void>
        let selectedFilterIndex: Observable<Int>
    }
    
    struct Output {
        let myMovieSectionDataArr: Observable<[MyMovieSectionData]>
        let pushMovieReview: Observable<Int>
        let isFilterListHidden: Observable<Bool>
        let selectedFilterIndex: Observable<Int>
    }
    
    private let bag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let myMovieCellDataArr = BehaviorSubject(value: fetchMyMovieCellDataArr())
        let isFilterListHidden = BehaviorSubject(value: true)
        let selectedFilterIndex = BehaviorSubject(value: 6) // All
        
        // 화면이 표시될 때마다 리스트 정보 갱신
        input.viewWillAppearEvent
            .compactMap { [weak self] _ in self?.fetchMyMovieCellDataArr() }
            .bind(to: myMovieCellDataArr)
            .disposed(by: bag)
        
        // 선택한 영화의 리뷰 화면으로 이동
        let pushMovieReview = input.modelSelected
            .map { $0.id }
        
        // 필터 버튼을 탭하면 필터 리스트를 표시
        input.filterButtonTapEvent
            .withLatestFrom(isFilterListHidden) { _, bool in !bool }
            .bind(to: isFilterListHidden)
            .disposed(by: bag)
        
        // 선택된 필터에 따라, 필터 버튼의 상태 업데이트
        input.selectedFilterIndex
            .bind(to: selectedFilterIndex)
            .disposed(by: bag)
            
        // 필터를 선택했을 때, 필터 리스트 닫기
        input.selectedFilterIndex
            .withLatestFrom(isFilterListHidden) { _, bool in !bool }
            .bind(to: isFilterListHidden)
            .disposed(by: bag)

        // 조건에 맞는 셀데이터를 내보내기 (6의 경우 All)
        let myMovieSectionDataArr = Observable
            .combineLatest(myMovieCellDataArr, selectedFilterIndex) { dataArr, index in
                index == 6 ? dataArr : dataArr.filter { $0.personalRate == index }
            }
            .map { $0.sectionDataArr } // RxDataSources 사용을 위해 (섹션을 안쓰지만)섹션으로 변환
            
        
        return Output(
            myMovieSectionDataArr: myMovieSectionDataArr,
            pushMovieReview: pushMovieReview,
            isFilterListHidden: isFilterListHidden.asObservable(),
            selectedFilterIndex: selectedFilterIndex
        )
    }
    
    // MARK: Methods
    
    private func fetchMyMovieCellDataArr() -> [MyMovieCellData] {
        CoreDataManager.shared.readAll().map {
            MyMovieCellData(
                id: $0.movieId,
                posterPath: $0.posterPath,
                personalRate: $0.personalRate,
                title: $0.title
            )
        }
    }
}
