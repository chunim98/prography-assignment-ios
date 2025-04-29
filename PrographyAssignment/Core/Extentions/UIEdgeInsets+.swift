//
//  UIEdgeInsets.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 10/1/24.
//

import UIKit

extension UIEdgeInsets {
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    init(
        top: CGFloat = .zero,
        left: CGFloat = .zero,
        bottom: CGFloat = .zero,
        right: CGFloat = .zero,
        _: AnyObject? = nil
    ) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
    
    init(edges: CGFloat) {
        self.init(top: edges, left: edges, bottom: edges, right: edges)
    }
}
