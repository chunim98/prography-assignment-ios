//
//  UIImage+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

extension UIImage {
    // 비율 유지하며 이미지 리사이즈
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        /// 이미지 비율 구하는 공식
        /// (original height / original width) x new width = new height
        
        let newHeight = (self.size.height/self.size.width) * newWidth
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
}
