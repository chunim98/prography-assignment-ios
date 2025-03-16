//
//  CarouselCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

struct CarouselCellData: MovieId {
    let backDropPath: String?
    let title: String
    let overview: String
    let id: Int
    
    init(backDropPath: String?, title: String, overview: String, id: Int) {
        self.backDropPath = backDropPath.map { "https://image.tmdb.org/t/p/original" + $0 }
        self.title = title
        self.overview = overview
        self.id = id
    }
}
