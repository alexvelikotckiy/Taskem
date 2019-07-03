//
//  CommonSourceInteractor.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskModelSourceInteractorOutput: TaskSourceInteractorOutput & GroupSourceInteractorOutput {
    func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel])
    func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel])
    func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId])
}

public extension TaskModelSourceInteractorOutput {
    func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [Task]) { }
    func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [Task]) { }

    func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {}
    func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {}
    func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {}
    func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {}
    func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {}
}

public protocol TaskModelSourceInteractor: TaskSourceInteractor, GroupSourceInteractor {
    var delegate: TaskModelSourceInteractorOutput? { get }
}

public extension TaskModelSourceInteractor {
    var interactorGroupsDelegate: GroupSourceInteractorOutput? {
        return delegate
    }
    
    var interactorTasksDelegate: TaskSourceInteractorOutput? {
        return delegate
    }
}

public extension TaskModelSourceInteractor {
    func fetchTaskModels( _ predicate: @escaping (TaskModel) -> Bool = { _ in return true },
                          _ completion: @escaping ([TaskModel]) -> Void) {
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async(group: dispatchGroup) {
            let result = self.sourceTasks.allTasks
                .compose(with: self.sourceGroups.allGroups)
                .filter(predicate)
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(result)
            }
        }
    }
    
    func sourceDidChangeState(_ source: TaskSource) {
        delegate?.interactorDidChangeStateTasks(self, state: source.state)
    }
    
    func source(_ source: TaskSource, didAdd tasks: [Task]) {
        let models = tasks.compose(with: sourceGroups.allGroups)
        delegate?.interactor(self, didAdd: models)
    }
    
    func source(_ source: TaskSource, didUpdate tasks: [Task]) {
        let models = tasks.compose(with: sourceGroups.allGroups)
        delegate?.interactor(self, didUpdate: models)
    }
    
    func source(_ source: TaskSource, didRemove ids: [EntityId]) {
        delegate?.interactor(self, didRemoveTasks: ids)
    }
}
