//
//  MovieReviewVC.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//

import UIKit

final class MovieReviewVC: UIViewController {

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBar(titleImage: UIImage(named: "prography_logo"))
    }

}

#Preview {
    UINavigationController(rootViewController: MovieReviewVC())
}
