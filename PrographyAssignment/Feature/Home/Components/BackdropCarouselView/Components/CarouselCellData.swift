//
//  CarouselCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

struct CarouselCellData {
    let title: String
    let overview: String
    let backDropPath: String
    
    init(title: String, overview: String, backDropPath: String) {
        self.title = title
        self.overview = overview
        self.backDropPath = "https://image.tmdb.org/t/p/original" + backDropPath
    }
}
