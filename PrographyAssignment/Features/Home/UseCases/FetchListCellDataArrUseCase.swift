//
//  FetchListCellDataArrUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

import RxSwift

final class FetchListCellDataArrUseCase {
    
    private let listCellDataRepository: ListCellDataArrRepositoryProtocol
    private let article: TMDBService.Article
    
    init(
        _ listCellDataRepository: ListCellDataArrRepositoryProtocol,
        _ article: TMDBService.Article
    ) {
        self.listCellDataRepository = listCellDataRepository
        self.article = article
    }
    
    func excute(page: Int ) -> Observable<[ListCellData]> {
        Observable.create { observer in
            Task {
                let fetched =
                try await self.listCellDataRepository.fetchListCellDataArr(self.article, page)
                
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
