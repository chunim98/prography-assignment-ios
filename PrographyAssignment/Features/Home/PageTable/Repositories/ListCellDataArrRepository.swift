//
//  ListCellDataArrRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

// MARK: Protocol

protocol ListCellDataArrRepositoryProtocol {
    func fetchListCellDataArr(
        _ article: TMDBService.Article,
        _ page: Int
    ) async throws -> [ListCellData]
}

// MARK: Implementation

final class ListCellDataArrRepositoryImpl: ListCellDataArrRepositoryProtocol {
    func fetchListCellDataArr(
        _ article: TMDBService.Article,
        _ page: Int
    ) async throws -> [ListCellData] {
        let fetched = try await TMDBService.shered.fetchMoviesInfo(article, page)
        return fetched.results.map { $0.toListCellData() }
    }
}
