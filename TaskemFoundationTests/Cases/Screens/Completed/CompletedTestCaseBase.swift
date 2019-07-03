//
//  CompletedTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class CompletedTestCaseBase: TaskemTestCaseBase {
    
    // Helpers
    var factoryTasks: TaskFactory!
    var factoryGroups: GroupFactory!
    var factoryTaskModel: TaskModelFactory!
    
    // Stubs
    var stubsModels: [TaskModel]!
    
    override func setUp() {
        super.setUp()
        
        factoryTasks = .init()
        factoryGroups = .init()
    
        stubsModels = produceStubs()
    }
    
    private func produceStubs() -> [TaskModel] {
        let taskOne = produceTaskModel(status: .recent)
        let taskTwo = produceTaskModel(status: .recent)
        let taskThree = produceTaskModel(status: .old)
        let taskFour = produceTaskModel(factoryTasks.make { $0.test_completionDate = nil })
        
        return [taskOne, taskTwo, taskThree, taskFour]
    }
    
    public func produceTaskModel(status: CompletedStatus) -> TaskModel {
        let task = produceTask(status: status)
        let group = factoryGroups.make { $0.id = task.idGroup }
        return .init(task: task, group: group)
    }
    
    public func produceTask(status: CompletedStatus) -> Task {
        return factoryTasks.make {
            $0.test_completionDate = status == .old ? Date.now.previousWeek : Date.now
        }
    }
    
    public func produceTaskModel(_ task: Task) -> TaskModel {
        let group = factoryGroups.make { $0.id = task.idGroup }
        return .init(task: task, group: group)
    }
}
