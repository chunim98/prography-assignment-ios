//
//  FetchCarouselCellDataArrUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

import RxSwift

final class FetchCarouselCellDataArrUseCase {
    
    private let carouselCellDataRepository: CarouselCellDataRepositoryProtocol
    
    init(_ carouselCellDataRepository: CarouselCellDataRepositoryProtocol) {
        self.carouselCellDataRepository = carouselCellDataRepository
    }
    
    func excute() -> Observable<[CarouselCellData]> {
        Observable<[CarouselCellData]>.create { observer in
            Task {
                let fetched = try await self.carouselCellDataRepository.fetch()
                observer.onNext(fetched)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
