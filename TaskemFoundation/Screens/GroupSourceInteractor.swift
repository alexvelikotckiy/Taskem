//
//  GroupSourceInteractor.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupSourceInteractorOutput: class {
    func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState)
    
    func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group])
    func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group])
    func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId])
    func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId])
}

public protocol GroupSourceInteractor: GroupSourceObserver {
    var sourceGroups: GroupSource { get }
    
    var interactorGroupsDelegate: GroupSourceInteractorOutput? { get }
    
    func start()
    func restart()
    func stop()
    
    func fetchGroups(_ predicate: @escaping (Group) -> Bool,
                     _ completion: @escaping ([Group]) -> Void)
    
    func insertGroups(_ groups: [Group])
    func updateGroups(_ groups: [Group])
    func removeGroups(_ byIds: [EntityId])
    func setDefaultGroup(_ id: EntityId)
    func reorderGroup(_ byId: EntityId, source: Int, destination: Int)
}

public extension GroupSourceInteractor {
    var sourceGroupsState: DataState {
        return sourceGroups.state
    }
    
    func findGroup(by id: EntityId) -> Group? {
        return sourceGroups.find(by: id)
    }
    
    func findGroupDefault() -> Group? {
        return sourceGroups.defaultGroup
    }
}

public extension GroupSourceInteractor {
    func fetchGroups( _ predicate: @escaping ((Group) -> Bool),
                      _ completion: @escaping ([Group]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var result: [Group] = []
        DispatchQueue.global().async(group: dispatchGroup) {
            result = self.sourceGroups.allGroups.filter(predicate)
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(result)
            }
        }
    }
    
    func insertGroups(_ groups: [Group]) {
        for var group in groups {
            if group.isDefault {
                group.isDefault = false
                sourceGroups.add(groups: [group])
                sourceGroups.setDefalut(byId: group.id)
            } else {
                sourceGroups.add(groups: [group])
            }
        }
    }
    
    func updateGroups(_ groups: [Group]) {
        for group in groups {
            if group.isDefault {
                sourceGroups.setDefalut(byId: group.id)
            }
            sourceGroups.update(groups: [group])
        }
    }
    
    func removeGroups(_ byIds: [EntityId]) {
        for id in byIds {
            if id == sourceGroups.info.defaultGroup {
                assert(false, "Can't remove a default group")
            }
            sourceGroups.remove(byIds: [id])
        }
    }
    
    func setDefaultGroup(_ id: EntityId) {
        sourceGroups.setDefalut(byId: id)
    }
    
    func reorderGroup(_ byId: EntityId, source: Int, destination: Int) {
        sourceGroups.reorder(byId: byId, source: source, destination: destination)
    }
}

public extension GroupSourceInteractor {
    func sourceDidChangeState(_ source: GroupSource) {
        interactorGroupsDelegate?.interactorDidChangeStateGroups(self, state: source.state)
    }

    func source(_ source: GroupSource, didAdd groups: [Group]) {
        interactorGroupsDelegate?.interactor(self, didAdd: groups)
    }

    func source(_ source: GroupSource, didUpdate groups: [Group]) {
        interactorGroupsDelegate?.interactor(self, didUpdate: groups)
    }

    func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        interactorGroupsDelegate?.interactor(self, didRemoveGroups: ids)
    }

    func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        interactorGroupsDelegate?.interactor(self, didUpdateGroupsOrder: ids)
    }
}
