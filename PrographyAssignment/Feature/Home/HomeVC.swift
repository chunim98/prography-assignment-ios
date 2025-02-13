//
//  HomeVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class HomeVC: UIViewController {
    // MARK: - Components
    
    let carouselCV = {
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        return cv
    }()
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarWillSet(titleImage: UIImage(named: "prography_logo"))
    }
    
    // MARK: - Layout
    
    // MARK: - Binding

}

#Preview {
    UINavigationController(rootViewController: HomeVC())
}
