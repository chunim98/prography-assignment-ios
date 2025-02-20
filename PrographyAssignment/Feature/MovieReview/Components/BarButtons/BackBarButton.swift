//
//  BackBarButton.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift

final class BackBarButton: UIBarButtonItem {

    // MARK: Life Cycle
    
    override init() {
        super.init()
        
        // 속성 초기화
        self.image = UIImage(named: "arrow_left")?.resizeImage(newWidth: 28)
        self.tintColor = UIColor(hex: 0x19191A)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Reactive

extension Reactive where Base: BackBarButton {
    var event: Observable<BarButtonEvent> { base.rx.tap.map { _ in .dismiss } }
}
