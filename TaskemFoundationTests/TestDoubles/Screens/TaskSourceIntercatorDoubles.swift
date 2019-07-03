//
//  TaskSourceIntercatorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskSourceInteractorDummy: TaskSourceInteractor {
    weak var delegate: TaskSourceInteractorObserverSpy?
    
    var sourceTasks: TaskSource
    
    init(sourceTasks: TaskSource) {
        self.sourceTasks = sourceTasks
    }
    
    var interactorTasksDelegate: TaskSourceInteractorOutput? {
        return delegate
    }
    
    func start() {
        
    }
    
    func restart() {
        
    }
    
    func stop() {
        
    }
}

//protocol TaskSourceInteractorSpy: TaskSourceInteractor {
//    var didStartCall: Int { get set }
//    var didRestartCall: Int { get set }
//    var didStopCall: Int { get set }
//    
//    var insertedTasks: [Task] { get set }
//    var updatedTasks: [Task] { get set }
//    var removedTasks: [EntityId] { get set }
//}
//
//extension TaskSourceInteractorSpy {
//    func start() {
//        didStartCall += 1
//    }
//    
//    func restart() {
//        didRestartCall += 1
//    }
//    
//    func stop() {
//        didStopCall += 1
//    }
//    
//    func insertTasks(_ tasks: [Task]) {
//        insertedTasks = tasks
//    }
//    
//    func updateTasks(_ tasks: [Task]) {
//        updatedTasks = tasks
//    }
//    
//    func removeTasks(_ byIds: [EntityId]) {
//        removedTasks = byIds
//    }
//}

class TaskSourceInteractorObserverSpy: TaskSourceInteractorOutput {
    var lastState: DataState!
    var added: [Task] = []
    var updated: [Task] = []
    var removed: [EntityId] = []
    
    func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        lastState = state
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [Task]) {
        added = tasks
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [Task]) {
        updated = tasks
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        removed = ids
    }
}
