//
//  DefaultMyMovieCellDataArrRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/30/25.
//

final class DefaultMyMovieCellDataArrRepository: MyMovieCellDataArrRepository {
    func readAll() -> [ReviewData] { ReviewDataManager.shared.readAll() }
}
