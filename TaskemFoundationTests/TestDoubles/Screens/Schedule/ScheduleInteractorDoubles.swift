//
//  ScheduleInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleInteractorDummy: ScheduleInteractor {
    var interactorDelegate: ScheduleInteractorOutput?
    
    var sourceTasks: TaskSource = TaskSourceDummy()
    var sourceGroups: GroupSource = GroupSourceDummy()
    
    func shareTasks(_ tasks: [Task]) {
        
    }
    
    func start() {
        
    }
    
    func restart() {
        
    }
    
    func stop() {
        
    }
}

class ScheduleInteractorMock: ScheduleInteractorDummy {
    
}

class ScheduleInteractorSpy: ScheduleInteractorMock {
    var didStartCall: Int = 0
    var didRestartCall: Int = 0
    var didStopCall: Int = 0
    var didShareTasks: [Task]?
    
    override func start() {
        didStartCall += 1
    }

    override func restart() {
        didRestartCall += 1
    }

    override func stop() {
        didStopCall += 1
    }
    
    override func shareTasks(_ tasks: [Task]) {
        didShareTasks = tasks
    }
}
