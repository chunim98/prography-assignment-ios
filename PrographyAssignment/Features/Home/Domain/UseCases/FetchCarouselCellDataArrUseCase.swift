//
//  FetchCarouselCellDataArrUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

import RxSwift

final class FetchCarouselCellDataArrUseCase {
    
    private let repository: CarouselCellDataRepository
    
    init(_ carouselCellDataRepository: CarouselCellDataRepository) {
        self.repository = carouselCellDataRepository
    }
    
    func execute() -> Observable<[CarouselCellData]> {
        Observable<[CarouselCellData]>.create { observer in
            Task {
                let fetched = try await self.repository.fetch()
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
