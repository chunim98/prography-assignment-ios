//
//  DefaultReviewDataRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//


final class DefaultReviewDataRepository: ReviewDataRepository {
    func read(movieId: Int) -> ReviewData? {
        CoreDataManager.shared.read(movieId: movieId)
    }
    
    func create(with reviewData: ReviewData) {
        CoreDataManager.shared.create(with: reviewData)
    }
    
    func update(with reviewData: ReviewData) {
        CoreDataManager.shared.update(with: reviewData)
    }
    
    func delete(_ reviewData: ReviewData) {
        CoreDataManager.shared.delete(reviewData)
    }
}
