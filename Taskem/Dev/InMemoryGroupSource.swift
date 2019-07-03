//
//  InMemoryGroupSource.swift
//  Taskem
//
//  Created by Wilson on 28.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

public class InMemoryGroupSource: GroupSource {
    public var observers: ObserverCollection<GroupSourceObserver>
    public var allGroups: [Group]
    
    public var info: GroupsInfo {
        return .init(
            defaultGroup: defaultGroup!.id,
            order: allGroups.map { $0.id }
        )
    }
    
    public var state: DataState {
        didSet {
            notifyDidChangeState()
        }
    }
    
    public init() {
        self.observers = .init()
        self.allGroups = []
        self.state = .notLoaded
    }

    public func start() {

    }

    public func stop() {

    }
    
    public func restart() {
        
    }

    public func reorder(byId: EntityId, source: Int, destination: Int) {
        if let origin = allGroups.firstIndex(where: { $0.id == byId }) {
            let target = allGroups[origin]
            allGroups.remove(at: origin)
            allGroups.insert(target, at: destination)
        }
        notifyUpdateOrder(ids: allGroups.map { $0.id })
    }

    public func setDefalut(byId: EntityId) {
        var updates: [Group] = []
        if let oldDefaultIndex = allGroups.firstIndex(where: { $0.isDefault == true }),
            let newDefaultIndex = allGroups.firstIndex(where: { $0.id == byId }) {

            allGroups[oldDefaultIndex].isDefault = false
            allGroups[newDefaultIndex].isDefault = true

            updates.append(allGroups[oldDefaultIndex])
            updates.append(allGroups[newDefaultIndex])
        }
        self.notifyUpdate(updates: updates)
    }

    public func add(groups: [Group]) {
        var insertions: [Group] = []
        for group in groups {
            self.allGroups.append(group)
            insertions.append(group)
        }
        self.notifyAdd(groups: insertions)
    }

    public func update(groups: [Group]) {
        var updates: [Group] = []
        for group in groups {
            if let index = allGroups.firstIndex(where: { $0.id == group.id }) {
                self.allGroups[index] = group
                updates.append(group)
            }
        }
        self.notifyUpdate(updates: updates)
    }

    public func remove(byIds: [EntityId]) {
        var deletions: [EntityId] = []
        for id in byIds {
            if let index = allGroups.firstIndex(where: { $0.id == id }) {
                self.allGroups.remove(at: index)
                deletions.append(id)
            }
        }
        self.notifyRemove(ids: deletions)
    }

    func notifyAdd(groups: [Group]) {
        for observer in observers {
            observer?.source(self, didAdd: groups)
        }
    }
    
}
