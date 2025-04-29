//
//  CarouselCellDataRepositoryProtocol.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 4/29/25.
//

protocol CarouselCellDataRepositoryProtocol {
    func fetch() async throws -> [CarouselCellData]
}
