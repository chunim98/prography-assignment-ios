//
//  ListCellDataArrRepository 2.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

protocol ListCellDataArrRepository {
    func fetchListCellDataArr(
        _ article: TMDBService.Article,
        _ page: Int
    ) async throws -> [ListCellData]
}
