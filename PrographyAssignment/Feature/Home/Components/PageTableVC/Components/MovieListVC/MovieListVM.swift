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
        
        // listCellDataArr 초기값 설정
        fetchMovieList()
            .map { fetched in
                fetched.map {
                    ListCellData(
                        posterPath: $0.posterPath,
                        title: $0.title,
                        overview: $0.overview,
                        voteAverage: $0.voteAverage,
                        genreIDS: $0.genreIDS
                    )
                }
            }
            .bind(to: listCellDataArr)
            .disposed(by: bag)
        
        return Output(
            listCellDataArr: listCellDataArr.asObservable()
        )
    }
    
    private func fetchMovieList() -> Observable<[MovieInfo.Result]> {
        Observable.create { observer in
            Task {
                #warning("Mock 데이터 사용중")
//                let fetched = try await TMDBNetworkManager.shered.fetchMovieList(self.article)
                let fetched = try await TMDBNetworkManager.shered.fetchMovieListMock()
                observer.onNext(fetched.results)
            }
            
            return Disposables.create()
        }
    }
}
