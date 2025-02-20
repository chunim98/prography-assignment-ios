//
//  Array+MyMovieCell.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/20/25.
//

import Foundation

extension Array where Element == MyMovieCellData {
    var sectionDataArr: [MyMovieSectionData] {
        [MyMovieSectionData(items: self)]
    }
}

extension Array where Element == MyMovieSectionData {
    var cellDataArr: [MyMovieCellData] {
        self.first?.items ?? [MyMovieCellData]()
    }
}
