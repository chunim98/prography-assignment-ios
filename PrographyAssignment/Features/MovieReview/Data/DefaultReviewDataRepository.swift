//
//  DefaultReviewDataRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//


final class DefaultReviewDataRepository: ReviewDataRepository {
    func read(movieId: Int) -> ReviewData? {
        ReviewDataManager.shared.read(movieId: movieId)
    }
    
    func create(with reviewData: ReviewData) {
        ReviewDataManager.shared.create(with: reviewData)
    }
    
    func update(with reviewData: ReviewData) {
        ReviewDataManager.shared.update(with: reviewData)
    }
    
    func delete(_ reviewData: ReviewData) {
        ReviewDataManager.shared.delete(reviewData)
    }
}
