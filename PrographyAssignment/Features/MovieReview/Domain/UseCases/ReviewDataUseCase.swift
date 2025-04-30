//
//  ReviewDataUseCase.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

final class ReviewDataUseCase {
    
    private let repository: ReviewDataRepository
    
    init(_ repository: ReviewDataRepository) { self.repository = repository }
    
    func read(movieId: Int) -> ReviewData? { repository.read(movieId: movieId) }
    func create(with reviewData: ReviewData) { repository.create(with: reviewData) }
    func update(with reviewData: ReviewData) { repository.update(with: reviewData) }
    func delete(_ reviewData: ReviewData) { repository.delete(reviewData) }
}

