//
//  GenreTagCollectionView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

final class GenreTagCollectionView: UICollectionView {
    
    /// UICollectionViewDelegateFlowLayout의 델리게이트 메서드가 뷰 계층에 보이는 게 보기 싫어서 만든 서브클래스.
    /// itemWidths를 업데이트 하고 invalidateLayout() 호출하면 됨.
    /// rxcocoa로 데이터 소스만 바인딩 한 경우에 사용가능, 그 외에는 델리게이트 프록시와 충돌이 발생할지도?
   
    var genreIds = [Int]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GenreTagCollectionView: UICollectionViewDelegateFlowLayout {
    
    // 컬렉션 뷰의 셀 너비를 가변적으로 적용
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let label = UILabel()
        label.text = genreIds[indexPath.row].genreName
        label.font = .pretendardSemiBold11
        label.sizeToFit() // 현재 폰트 크기에 맞게 frame이 자동으로 조정됨
        return CGSize(width: label.frame.width+12, height: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        4
    }
}
