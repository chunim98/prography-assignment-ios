//
//  UIColor+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/14/25.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var brandColor: UIColor {
        UIColor(hex: 0xD81D45)
    }
    
    static var onSurfaceVariant: UIColor {
        UIColor(hex: 0x49454F)
    }
    
    static var onSurface: UIColor {
        UIColor(hex: 0x1D1B20)
    }
}
