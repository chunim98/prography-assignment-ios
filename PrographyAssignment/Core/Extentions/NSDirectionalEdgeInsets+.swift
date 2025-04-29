//
//  NSDirectionalEdgeInsets.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 10/1/24.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func + (lhs: NSDirectionalEdgeInsets, rhs: NSDirectionalEdgeInsets) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }

    init(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero,
        _: AnyObject? = nil
    ) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    init(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    init(edges: CGFloat) {
        self.init(top: edges, leading: edges, bottom: edges, trailing: edges)
    }
}
