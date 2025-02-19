//
//  ReviewedMovieCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import Foundation

struct ReviewedMovieCellData: MovieId {
    let id: Int
    let posterPath: String
    let personalRate: Int
    let title: String
    
    init(id: Int, posterPath: String, personalRate: Int, title: String) {
        self.id = id
        self.posterPath = "https://image.tmdb.org/t/p/original" + posterPath
        self.personalRate = personalRate
        self.title = title
    }
}
