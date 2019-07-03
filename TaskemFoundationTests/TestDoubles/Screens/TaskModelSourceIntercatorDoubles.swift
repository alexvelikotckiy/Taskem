//
//  CommonSourceIntercatorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskModelSourceIntercatorDummy: TaskModelSourceInteractor {
    weak var delegate: TaskModelSourceInteractorOutput?
    
    var sourceTasks: TaskSource
    var sourceGroups: GroupSource
    
    init(sourceTasks: TaskSource,
                sourceGroups: GroupSource) {
        self.sourceTasks = sourceTasks
        self.sourceGroups = sourceGroups
    }
    
    var interactorDelegate: TaskModelSourceInteractorOutput? {
        return delegate
    }
    
    func start() {
        
    }
    
    func restart() {
        
    }
    
    func stop() {
        
    }
}

class TaskModelSourceInteractorObserverSpy: TaskModelSourceInteractorOutput {
    var lastTasksState: DataState!
    var addedTasksModel: [TaskModel] = []
    var updatedTasksModel: [TaskModel] = []
    var removedTasks: [EntityId] = []
    
    func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        lastTasksState = state
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        addedTasksModel = tasks
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        updatedTasksModel = tasks
    }
    
    func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        removedTasks = ids
    }
}
