//
//  MovieDetailRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//


protocol MovieDetailRepository {
    func fetchMovieDetail(_ id: Int) async throws -> MovieDetailDTO
}