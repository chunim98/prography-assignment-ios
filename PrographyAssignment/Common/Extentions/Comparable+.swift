//
//  Comparable+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

extension Comparable {
    func clamped(_ range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
