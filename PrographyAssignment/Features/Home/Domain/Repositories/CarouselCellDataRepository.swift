//
//  CarouselCellDataRepository.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

protocol CarouselCellDataRepository {
    func fetch() async throws -> [CarouselCellData]
}
