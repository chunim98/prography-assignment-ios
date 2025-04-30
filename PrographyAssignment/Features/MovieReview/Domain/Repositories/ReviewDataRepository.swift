//
//  ReviewDataRepository 2.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//


protocol ReviewDataRepository {
    func readAll() -> [ReviewData]
    func read(movieId: Int) -> ReviewData?
    func create(with reviewData: ReviewData)
    func update(with reviewData: ReviewData)
    func delete(_ reviewData: ReviewData)
}