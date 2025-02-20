//
//  Array+ReviewedMovieCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/20/25.
//

import Foundation

extension Array where Element == ReviewedMovieCellData {
    var sectionDataArr: [ReviewedMovieSection] {
        [ReviewedMovieSection(items: self)]
    }
}

extension Array where Element == ReviewedMovieSection {
    var cellDataArr: [ReviewedMovieCellData] {
        self.first?.items ?? [ReviewedMovieCellData]()
    }
}
