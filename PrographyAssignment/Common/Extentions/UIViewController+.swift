//
//  UIView.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import UIKit

extension UIViewController {
    func presentAlert(
        title: String,
        message: String,
        acceptTitle: String = String(localized: "확인"),
        cancelTitle: String = String(localized: "취소"),
        acceptTask: (() -> Void)? = nil,
        cancelTask: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: acceptTitle, style: .default) { _ in acceptTask?() }
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in cancelTask?() }
        
        alert.addAction(accept)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAcceptAlert(
        title: String,
        message: String,
        acceptTitle: String = String(localized: "확인"),
        acceptTask: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let accept = UIAlertAction(title: acceptTitle, style: .default) { _ in acceptTask?() }
        
        alert.addAction(accept)
            
        self.present(alert, animated: true, completion: nil)
    }

    // 스크롤 해도 색이 변하지 않는 네비게이션 바 구성
    func setNavigationBar(
        leftBarButtonItems: [UIBarButtonItem]? = nil,
        rightBarButtonItems: [UIBarButtonItem]? = nil,
        title: String? = nil,
        titleImage: UIImage? = nil
    ) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear // 그림자 없애기
        
        // 네비게이션 바 구성
        if let title {
            
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.black // 타이틀 색깔
            ]
            navigationController?.navigationBar.tintColor = .black
            self.title = title
        }
        if let titleImage {
            self.navigationItem.titleView = UIImageView(image: titleImage)
        }
        if let leftBarButtonItems {
            navigationItem.leftBarButtonItems = leftBarButtonItems
        }
        if let rightBarButtonItems {
            navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
}
