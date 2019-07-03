//
//  GroupSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

public protocol GroupSourceObserver: class {
    func sourceDidChangeState(_ source: GroupSource)
    func source(_ source: GroupSource, didAdd groups: [Group])
    func source(_ source: GroupSource, didUpdate groups: [Group])
    func source(_ source: GroupSource, didRemove ids: [EntityId])
    func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId])
}

public protocol GroupSource: class {
    var observers: ObserverCollection<GroupSourceObserver> { get set }
    var allGroups: [Group] { get }
    var info: GroupsInfo { get }
    var state: DataState { get }

    func start()
    func stop()
    func restart()

    func reorder(byId: EntityId, source: Int, destination: Int)
    func setDefalut(byId: EntityId)
    func add(groups: [Group])
    func update(groups: [Group])
    func remove(byIds: [EntityId])
}

public extension GroupSource {
    func addObserver(_ observer: GroupSourceObserver) {
        self.observers.append(observer)
    }
    
    func removeObserver(_ observer: GroupSourceObserver) {
        observers.remove(observer)
    }

    func notifyDidChangeState() {
        for observer in observers {
            observer?.sourceDidChangeState(self)
        }
    }

    func notifyAdd(groups: [Group]) {
        for observer in observers {
            observer?.source(self, didAdd: groups)
        }
    }

    func notifyUpdate(updates: [Group]) {
        for observer in observers {
            observer?.source(self, didUpdate: updates)
        }
    }

    func notifyRemove(ids: [EntityId]) {
        for observer in observers {
            observer?.source(self, didRemove: ids)
        }
    }

    func notifyUpdateOrder(ids: [EntityId]) {
        for observer in observers {
            observer?.source(self, didUpdateOrderSequence: ids)
        }
    }
}

public extension GroupSource {
    var defaultGroup: Group? {
        return allGroups.first(where: { $0.isDefault })
    }
    
    func find(by id: EntityId) -> Group? {
        return allGroups.first(where: { $0.id == id })
    }
}
