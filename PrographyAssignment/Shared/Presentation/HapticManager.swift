//
//  HapticManager.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/17/25.
//


import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private let ligthFeedback = UIImpactFeedbackGenerator(style: .light)
    private let rigidFeedback = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    private let selectFeedback = UISelectionFeedbackGenerator()
    
    
    private init() {}
    
    func occurLight(intensity: CGFloat = 1.0) {
        ligthFeedback.impactOccurred(intensity: intensity)
    }
    
    func occurRigid(intensity: CGFloat = 1.0) {
        rigidFeedback.impactOccurred(intensity: intensity)
    }
    
    func occurSuccess() {
        notificationFeedback.notificationOccurred(.success)
    }
    
    func occurError() {
        notificationFeedback.notificationOccurred(.error)
    }
    
    func occurWarning() {
        notificationFeedback.notificationOccurred(.warning)
    }
    
    func occurSelect() {
        selectFeedback.selectionChanged()
    }
    
}
