//
//  NowPlaying.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import Foundation

struct NowPlaying: Codable {
    let dates: NowPlaying.Dates
    let page: Int
    let results: [NowPlaying.Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    // MARK: Dates

    struct Dates: Codable {
        let maximum, minimum: String
    }

    // MARK: Result

    struct Result: Codable {
        let adult: Bool
        let backdropPath: String
        let genreIDS: [Int]
        let id: Int
        let originalLanguage: OriginalLanguage
        let originalTitle: String
        let overview: String
        let popularity: Double
        let posterPath: String
        let releaseDate: String
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int

        enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    }

    enum OriginalLanguage: String, Codable {
        case en = "en"
        case es = "es"
        case fr = "fr"
        case zh = "zh"
    }
}

