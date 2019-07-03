//
//  InMemoryTaskSource.swift
//  Taskem
//
//  Created by Wilson on 28.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

public class InMemoryTaskSource: TaskSource {
    public var observers: ObserverCollection<TaskSourceObserver>
    public var allTasks: [Task]

    public var state: DataState {
        didSet {
            notifyDidChangeState()
        }
    }
    
    public init() {
        self.observers = .init()
        self.allTasks = []
        self.state = .notLoaded
    }

    public func start() {

    }

    public func stop() {

    }
    
    public func restart() {
        
    }

    public func add(tasks: [Task]) {
        var insertions: [Task] = []
        for task in tasks {
            self.allTasks.append(task)
            insertions.append(task)
        }
        notifyAdd(tasks: insertions)
    }

    public func update(tasks updated: [Task]) {
        let ids = updated.map { $0.id }
        let remainder = allTasks.filter { !ids.contains($0.id) }
        self.allTasks = updated + remainder
        notifyUpdate(updates: updated)
    }

    public func remove(byIds: [EntityId]) {
        var deletions: [EntityId] = []
        for id in byIds {
            if let index = allTasks.firstIndex(where: { $0.id == id }) {
                self.allTasks.remove(at: index)
                deletions.append(id)
            }
        }
        notifyRemove(ids: deletions)
    }

    func notifyAdd(tasks: [Task]) {
        for observer in observers {
            observer?.source(self, didAdd: tasks)
        }
    }
    
}

extension InMemoryTaskSource: GroupSourceObserver {
    
    public func sourceDidChangeState(_ source: GroupSource) {
        
    }

    public func source(_ source: GroupSource, didUpdate groups: [Group]) {
        let ids = groups.map { $0.id }
        let tasks = allTasks.filter { ids.contains($0.idGroup) }
        self.notifyUpdate(updates: tasks)
    }

    public func source(_ source: GroupSource, didAdd groups: [Group]) {

    }

    public func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        let allTasks = self.allTasks.filter { !ids.contains($0.idGroup) }
        self.allTasks = allTasks
    }

    public func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {

    }
}
