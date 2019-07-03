//
//  Timer.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TimerProtocol {
    var isValid: Bool { get }
    
    func start()
    func stop()
    func setOnTick(_ handler: @escaping () -> Void)
}

public class SystemTimer: TimerProtocol {
    private var timer: Timer?
    private var handler: (() -> Void)?
    
    public init() {
        
    }
    
    public func start() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }
    
    public var isValid: Bool {
        return timer?.isValid ?? false
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    public func setOnTick(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    @objc private func tick() {
        handler?()
    }
}
