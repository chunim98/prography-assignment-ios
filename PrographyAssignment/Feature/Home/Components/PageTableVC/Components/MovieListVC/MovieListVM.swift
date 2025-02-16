//
//  MovieListVM.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/15/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MovieListVM {
    
    struct Input {
        let currentCellIndex: Observable<Int>
    }
    
    struct Output {
        let listCellDataArr: Observable<[ListCellData]>
    }
    
    // MARK: Properties
    
    private let article: TMDBNetworkManager.Article
    private let bag = DisposeBag()
        
    init(_ article: TMDBNetworkManager.Article) { self.article = article }
    
    func transform(input: Input) -> Output {
        let listCellDataArr = BehaviorSubject(value: [ListCellData]())
        let loadPage = BehaviorSubject(value: 1)
        let isLoading = BehaviorSubject(value: false)

        // loadPage값이 변할 때마다 새로운 페이지 누적
        loadPage
            .debug()
            .flatMapLatest(fetchListCellDataArr(page:))
            .withLatestFrom(listCellDataArr) { $1 + $0 } // 기존+신규
            .bind(to: listCellDataArr)
            .disposed(by: bag)
        
        // 스크롤 해서 거의 마지막에 있는 셀을 만나면 로딩중으로 상태 변경
        input.currentCellIndex
            .withLatestFrom(listCellDataArr) { ($0, $1.count-1) }
            .filter { $1 - $0 < 4 }
            .map { _ in true }
            .bind(to: isLoading)
            .disposed(by: bag)
        
        // 로딩중일 경우 다음페이지를 요청하기 위해 loadPage 값 업데이트
        isLoading
            .distinctUntilChanged()
            .filter { $0 } // 로딩중일 때만 다음 페이지를 요청 가능
            .withLatestFrom(loadPage) { $1 + 1 }
            .bind(to: loadPage)
            .disposed(by: bag)
        
        // 로딩이 끝나고 페이지를 갱신했다면 로딩중 상태를 해제
        listCellDataArr
            .map { _ in false }
            .bind(to: isLoading)
            .disposed(by: bag)
        
        return Output(
            listCellDataArr: listCellDataArr.asObservable()
        )
    }
    
    private func fetchListCellDataArr(page: Int) -> Observable<[ListCellData]> {
        Observable.create { observer in
            Task {
                #warning("Mock 데이터 사용중")
                // let fetched = try await TMDBNetworkManager.shered.fetchMovieList(self.article)
                let fetched = try await TMDBNetworkManager.shered.fetchMovieListMock()
                let listCellDataArr = fetched.results.map {
                    ListCellData(
                        posterPath: $0.posterPath,
                        title: $0.title,
                        overview: $0.overview,
                        voteAverage: $0.voteAverage,
                        genreIDS: $0.genreIDS
                    )
                }
                try await Task.sleep(nanoseconds: 500000000)
                observer.onNext(listCellDataArr)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
}
