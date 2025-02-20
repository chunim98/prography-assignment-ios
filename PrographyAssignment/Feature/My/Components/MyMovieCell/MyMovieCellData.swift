//
//  MyMovieCellData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import Foundation

import Differentiator

struct MyMovieCellData: MovieId {
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

// MARK: RxDataSources

extension MyMovieCellData: Equatable, IdentifiableType {
    // 이게 달라지면 rx데이터소스에서 insert처리
    var identity: Int { self.id }
    
    // 이게 false면 rx데이터소스에서 reload처리
    static func == (lhs: MyMovieCellData, rhs: MyMovieCellData) -> Bool {
        lhs.id == rhs.id && lhs.personalRate == rhs.personalRate
    }
}

struct MyMovieSectionData: AnimatableSectionModelType {
    var items: [MyMovieCellData]
    var identity: String = "NoneSection"
    
    init(original: MyMovieSectionData, items: [MyMovieCellData]) {
        self = original
        self.items = items
    }
    init(items: [MyMovieCellData]) { self.items = items }
}
