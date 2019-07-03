//
//  TaskPoupInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskPopupInteractorDummy: TaskPopupInteractor {
    var interactorDelegate: TaskPopupInteractorOutput?
    
    var sourceGroups: GroupSource = GroupSourceDummy()
    var sourceTasks: TaskSource = TaskSourceDummy()
        
    init(sourceTasks: TaskSource,
         sourceGroups: GroupSource) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
    }
    
    func start() {
        
    }
    
    func restart() {
        
    }
    
    func stop() {
        
    }
}

class TaskPopupInteractorSpy: TaskPopupInteractorDummy {
    var didStartCall: Int = 0
    var didRestartCall: Int = 0
    var didStopCall: Int = 0
    
    override func start() {
        didStartCall += 1
    }
    
    override func restart() {
        didRestartCall += 1
    }
    
    override func stop() {
        didStopCall += 1
    }
}
