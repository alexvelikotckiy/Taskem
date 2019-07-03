//
//  TaskSourceInteractor.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskSourceInteractorOutput: class {
    func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState)
    
    func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [Task])
    func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [Task])
    func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId])
}

public protocol TaskSourceInteractor: TaskSourceObserver {    
    var sourceTasks: TaskSource { get }
    
    var interactorTasksDelegate: TaskSourceInteractorOutput? { get }
    
    func start()
    func restart()
    func stop()
    
    func fetchTasks(_ predicate: @escaping (Task) -> Bool,
                    _ completion: @escaping ([Task]) -> Void)
    
    func insertTasks(_ tasks: [Task])
    func updateTasks(_ tasks: [Task])
    func removeTasks(_ byIds: [EntityId])
}

public extension TaskSourceInteractor {
    var sourceTasksState: DataState {
        return sourceTasks.state
    }
    
    func findTask(by id: EntityId) -> Task? {
        return sourceTasks.find(by: id)
    }
}

public extension TaskSourceInteractor {
    func fetchTasks( _ predicate: @escaping (Task) -> Bool,
                     _ completion: @escaping ([Task]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var result: [Task] = []
        DispatchQueue.global().async(group: dispatchGroup) {
            result = self.sourceTasks.allTasks.filter(predicate)
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(result)
            }
        }
    }
    
    func insertTasks(_ tasks: [Task]) {
        sourceTasks.add(tasks: tasks)
    }

    func updateTasks(_ tasks: [Task]) {
        sourceTasks.update(tasks: tasks)
    }

    func removeTasks(_ byIds: [EntityId]) {
        sourceTasks.remove(byIds: byIds)
    }
}

public extension TaskSourceInteractor {
    func sourceDidChangeState(_ source: TaskSource) {
        interactorTasksDelegate?.interactorDidChangeStateTasks(self, state: source.state)
    }

    func source(_ source: TaskSource, didAdd tasks: [Task]) {
        interactorTasksDelegate?.interactor(self, didAdd: tasks)
    }

    func source(_ source: TaskSource, didUpdate tasks: [Task]) {
        interactorTasksDelegate?.interactor(self, didUpdate: tasks)
    }

    func source(_ source: TaskSource, didRemove ids: [EntityId]) {
        interactorTasksDelegate?.interactor(self, didRemoveTasks: ids)
    }
}
