//
//  DefaultListCellDataArrRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

final class DefaultListCellDataArrRepository: ListCellDataArrRepository {
    func fetchListCellDataArr(
        _ article: TMDBService.Article,
        _ page: Int
    ) async throws -> [ListCellData] {
        let fetched = try await TMDBService.shered.fetchMoviesInfo(article, page)
        return fetched.results.map { $0.toListCellData() }
    }
}
