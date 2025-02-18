//
//  SaveBarButton.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//

import UIKit

import RxSwift

final class SaveBarButton: UIBarButtonItem {
    
    // MARK: Interface
    
    fileprivate let event = PublishSubject<BarButtonEvent>()
    
    // MARK: Life Cycle
    
    override init() {
        super.init()
        
        // 속성 초기화
        self.title = "저장"
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Reactive

extension Reactive where Base: SaveBarButton {
    var event: Observable<BarButtonEvent> { base.rx.tap.map { _ in .delete } }
}

