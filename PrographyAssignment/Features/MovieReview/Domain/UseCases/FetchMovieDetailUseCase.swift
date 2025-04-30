//
//  FetchMovieDetailUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

import RxSwift

final class FetchMovieDetailUseCase {
    private let repository: MovieDetailRepository
    
    init(_ repository: MovieDetailRepository) {
        self.repository = repository
    }
    
    func execute(_ id: Int) -> Observable<MovieDetailDTO> {
        Observable.create { observer in
            Task { @MainActor in
                let fetched = try await self.repository.fetchMovieDetail(id)
                observer.onNext(fetched)
            }
            
            return Disposables.create()
        }
    }
}
