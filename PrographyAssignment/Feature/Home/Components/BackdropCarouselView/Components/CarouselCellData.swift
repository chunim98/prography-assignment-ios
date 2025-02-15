//
//  CarouselCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

struct CarouselCellData {
    let backDropPath: String
    let title: String
    let overview: String
    
    init(backDropPath: String, title: String, overview: String) {
        self.backDropPath = "https://image.tmdb.org/t/p/original" + backDropPath
        self.title = title
        self.overview = overview
    }
}
