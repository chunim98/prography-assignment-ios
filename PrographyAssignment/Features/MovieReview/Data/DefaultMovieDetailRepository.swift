//
//  DefaultMovieDetailRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//


final class DefaultMovieDetailRepository: MovieDetailRepository {
    func fetchMovieDetail(_ id: Int) async throws -> MovieDetailDTO {
        try await TMDBService.shered.fetchMovieDetail(id)
    }
}