//
//  FetchListCellDataArrUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

import RxSwift

final class FetchListCellDataArrUseCase {
    
    private let repository: ListCellDataArrRepository
    private let article: TMDBService.Article
    
    init(
        _ repository: ListCellDataArrRepository,
        _ article: TMDBService.Article
    ) {
        self.repository = repository
        self.article = article
    }
    
    func execute(page: Int ) -> Observable<[ListCellData]> {
        Observable.create { observer in
            Task {
                let fetched =
                try await self.repository.fetchListCellDataArr(self.article, page)
                
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
