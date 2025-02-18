//
//  MovieInfo.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import Foundation

struct MovieInfo: Codable {
    let page: Int
    let results: [MovieInfo.Result]

    enum CodingKeys: String, CodingKey {
        case page
        case results
    }

    // MARK: Result
    struct Result: Codable {
        let backdropPath: String
        let genreIDS: [Int]
        let id: Int
        let overview: String
        let posterPath: String
        let title: String
        let voteAverage: Double

        enum CodingKeys: String, CodingKey {
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case overview
            case posterPath = "poster_path"
            case title
            case voteAverage = "vote_average"
        }
    }
}

