//
//  UIFont+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

extension UIFont {
    static var pretendardBold45: UIFont! { UIFont(name: "Pretendard-Bold", size: 45) }
    static var pretendardBold22: UIFont! { UIFont(name: "Pretendard-Bold", size: 22) }
    static var pretendardBold16: UIFont! { UIFont(name: "Pretendard-Bold", size: 16) }
    static var pretendardBold14: UIFont! { UIFont(name: "Pretendard-Bold", size: 14) }

    static var pretendardSemiBold16: UIFont! { UIFont(name: "Pretendard-SemiBold", size: 16) }
    static var pretendardSemiBold14: UIFont! { UIFont(name: "Pretendard-SemiBold", size: 14) }
    static var pretendardSemiBold11: UIFont! { UIFont(name: "Pretendard-SemiBold", size: 11) }

    static var pretendardMedium16: UIFont! { UIFont(name: "Pretendard-Medium", size: 16) }
    
    static var pretendardRegular11: UIFont! { UIFont(name: "Pretendard-Regular", size: 11) }
    
    var attributeContainer: AttributeContainer {
        var container = AttributeContainer()
        container.font = self
        return container
    }
}
