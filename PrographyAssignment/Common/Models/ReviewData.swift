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
    let title: String
    let commentData: CommentData?
    
    struct CommentData {
        let comment: String
        let date: Date
    }
}

extension ReviewData {
    // 멤버와이즈 생성자 유지하려고 확장에다가 선언
    init() {
        self.movieId = 0
        self.posterPath = ""
        self.personalRate = 0
        self.date = Date()
        self.title = ""
        self.commentData = nil
    }
    
    func updated(
        movieId: Int? = nil,
        posterPath: String? = nil,
        personalRate: Int? = nil,
        date: Date? = nil,
        title: String? = nil,
        commentData: CommentData?? = nil // 옵셔널을 유지하기 위해 중첩 옵셔널 사용
    ) -> Self {
        ReviewData(
            movieId: movieId ?? self.movieId,
            posterPath: posterPath ?? self.posterPath,
            personalRate: personalRate ?? self.personalRate,
            date: date ?? self.date,
            title: title ?? self.title,
            commentData: commentData ?? self.commentData
        )
    }
}

extension ReviewData.CommentData {
    func updated(
        comment: String? = nil,
        date: Date? = nil
    ) -> Self {
        ReviewData.CommentData(
            comment: comment ?? self.comment,
            date: date ?? self.date
        )
    }
}
