//
//  DefaultCarouselCellDataRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

final class DefaultCarouselCellDataRepository: CarouselCellDataRepository {
    func fetch() async throws -> [CarouselCellData] {
        let fetched = try await TMDBService.shered.fetchMoviesInfo(.nowPlaying, 1)
        return fetched.results.map { $0.toCarouselCellData() }
    }
}
