//
//  UICollectionView+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

extension UICollectionView {
    func setSinglelineLayout(
        spacing: CGFloat,
        itemSize: CGSize,
        sectionInset: UIEdgeInsets = .zero
    ) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal // 스크롤 방향
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = .zero // 스크롤 방향 기준 아이템 간 간격
        flowLayout.minimumLineSpacing = spacing // 스크롤 방향 기준 열 간격
        flowLayout.sectionInset = sectionInset
        
        self.collectionViewLayout = flowLayout
    }
}
