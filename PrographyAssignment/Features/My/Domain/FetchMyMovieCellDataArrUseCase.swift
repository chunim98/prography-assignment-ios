//
//  FetchMyMovieCellDataArrUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

final class FetchMyMovieCellDataArrUseCase {
    
    private let repository: MyMovieCellDataArrRepository
    
    init(_ repository: MyMovieCellDataArrRepository) {
        self.repository = repository
    }
    
    func execute() -> [MyMovieCellData] {
        repository.readAll().map {
            MyMovieCellData(
                id: $0.movieId,
                posterPath: $0.posterPath,
                personalRate: $0.personalRate,
                title: $0.title
            )
        }
    }
}
