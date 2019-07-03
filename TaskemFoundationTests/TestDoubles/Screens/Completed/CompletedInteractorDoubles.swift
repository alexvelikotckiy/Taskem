//
//  CompletedInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class CompletedInteractorDummy: CompletedInteractor {
    var sourceTasks: TaskSource = TaskSourceDummy()
    var sourceGroups: GroupSource = GroupSourceDummy()
    
    var interactorDelegate: CompletedInteractorOutput?
    
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

class CompletedInteractorMock: CompletedInteractorDummy {
 
}

class CompletedInteractorSpy: CompletedInteractorMock {
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
