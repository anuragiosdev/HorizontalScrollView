//
//  TimerManager.swift
//  SwiftUITest
//
//  Created by Anurag Sharma on 31/05/24.
//

import Foundation
import SwiftUI
import Combine

class TimerManager: ObservableObject {
    private var timer: Timer?
    private let interval: TimeInterval
    private let repeats: Bool
    var action: (() -> Void)?
    
    @Published var isRunning: Bool = false
    
    init(interval: TimeInterval, repeats: Bool) {
        self.interval = interval
        self.repeats = repeats
    }
    
    func setAction(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    func start() {
        guard !isRunning else { return }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { [weak self] _ in
            self?.action?()
        }
        isRunning = true
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
}
