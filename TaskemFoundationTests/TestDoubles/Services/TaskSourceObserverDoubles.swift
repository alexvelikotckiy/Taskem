//
//  TaskSourceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/20/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskSourceObserverSpy: TaskSourceObserverSpyProtocol {
    var lastTasksStateChange: DataState = .notLoaded
    var addedTasks: [Task] = []
    var updatedTasks: [Task] = []
    var removedTasks: [EntityId] = []
}

class TaskSourceWithObserversStub: TaskSource {
    var observers: ObserverCollection<TaskSourceObserver> = []
    var allTasks: [Task] = []
    var state: DataState = .notLoaded
    
    func setState(_ state: DataState) {
        self.state = state
    }
    
    init(observers: ObserverCollection<TaskSourceObserver>) {
        self.observers = observers
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func restart() {
        
    }
    
    func add(tasks: [Task]) {
        
    }
    
    func update(tasks: [Task]) {
        
    }
    
    func remove(byIds: [EntityId]) {
        
    }
}

protocol TaskSourceObserverSpyProtocol: TaskSourceObserver {
    var lastTasksStateChange: DataState { get set }
    var addedTasks: [Task] { get set }
    var updatedTasks: [Task] { get set }
    var removedTasks: [EntityId] { get set }
}

extension TaskSourceObserverSpyProtocol {
    func sourceDidChangeState(_ source: TaskSource) {
        lastTasksStateChange = source.state
    }
    
    func source(_ source: TaskSource, didAdd tasks: [Task]) {
        addedTasks.append(contentsOf: tasks)
    }
    
    func source(_ source: TaskSource, didUpdate tasks: [Task]) {
        updatedTasks.append(contentsOf: tasks)
    }
    
    func source(_ source: TaskSource, didRemove ids: [EntityId]) {
        removedTasks.append(contentsOf: ids)
    }
}
