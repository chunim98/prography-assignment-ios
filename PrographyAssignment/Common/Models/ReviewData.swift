//
//  ReviewData.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import Foundation

struct ReviewData {
    let movieId: Int
    let posterPath: String
    let personalRate: Int
    let date: Date
    let commentData: CommentData?
    
    struct CommentData {
        let comment: String
        let date: Date
    }
}
