//
//  PullDownBarButton.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import UIKit

import RxSwift

final class PullDownBarButton: UIBarButtonItem {
    
    // MARK: Interface
    
    fileprivate let event = PublishSubject<BarButtonEvent>()
    
    // MARK: Life Cycle
    
    override init() {
        super.init()
        
        // 속성 초기화
        self.image = UIImage(named: "eclipse")?.resizeImage(newWidth: 28)
        self.tintColor = UIColor(hex: 0x24282F)
        self.style = .plain
        setMenu()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Menu
    
    private func setMenu() {
        let edit = UIAction(title: "수정하기") {
            [weak self] _ in self?.event.onNext(.edit)
        }
        
        let delete = UIAction(title: "삭제하기", attributes: .destructive) {
            [weak self] _ in self?.event.onNext(.delete)
        }
        
        self.menu = UIMenu(children: [edit, delete])
    }
}

// MARK: - Reactive

extension Reactive where Base: PullDownBarButton {
    var event: Observable<BarButtonEvent> { base.event.asObservable() }
}
