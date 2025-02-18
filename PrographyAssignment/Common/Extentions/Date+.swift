//
//  Date+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import Foundation

extension Date {
    var string: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
