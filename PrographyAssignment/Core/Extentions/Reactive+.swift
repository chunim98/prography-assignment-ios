//
//  Reactive+.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/21/25.
//

import UIKit

import RxSwift

extension Reactive where Base: UIView {
    var isHiddenWithAnime: Binder<Bool> {
        Binder(base) { $0.isHiddenWithAnime = $1 }
    }
}
