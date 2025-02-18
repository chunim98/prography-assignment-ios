//
//  MovieDetails.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import Foundation

struct MovieDetails: Codable {
    let genres: [Genre]
    let id: Int
    let overview: String
    let posterPath: String
    let title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case genres, id, overview
        case posterPath = "poster_path"
        case title
        case voteAverage = "vote_average"
    }
    
    // MARK: Genre
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
}
