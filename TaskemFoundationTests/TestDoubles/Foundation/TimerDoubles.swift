//
//  TimerDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TimerMock: TimerProtocol {
    var isValid: Bool = false
    var handler: (() -> Void)?
    
    func start() {
        isValid = true
    }
    
    func stop() {
        isValid = false
    }
    
    func setOnTick(_ handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func tick() {
        handler?()
    }
}
