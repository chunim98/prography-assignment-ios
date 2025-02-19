//
//  MyVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class MyVC: UIViewController {
    
    // MARK: Properties
    
    private let bag = DisposeBag()

    // MARK: Components


    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
    }

    // MARK: Layout

    // MARK: Binding
}

#Preview {
    UINavigationController(rootViewController: MyVC())
}
