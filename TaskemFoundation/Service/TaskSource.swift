//
//  TasksSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

public protocol TaskSourceObserver: class {
    func sourceDidChangeState(_ source: TaskSource)
    func source(_ source: TaskSource, didAdd tasks: [Task])
    func source(_ source: TaskSource, didUpdate tasks: [Task])
    func source(_ source: TaskSource, didRemove ids: [EntityId])
}

public protocol TaskSource: class {
    var observers: ObserverCollection<TaskSourceObserver> { get set }
    var allTasks: [Task] { get }
    var state: DataState { get }
    
    func start()
    func stop()
    func restart()

    func add(tasks: [Task])
    func update(tasks: [Task])
    func remove(byIds: [EntityId])
}

public extension TaskSource {
    func addObserver(_ observer: TaskSourceObserver) {
        self.observers.append(observer)
    }

    func removeObserver(_ observer: TaskSourceObserver) {
        observers.remove(observer)
    }

    func notifyDidChangeState() {
        for observer in observers {
            observer?.sourceDidChangeState(self)
        }
    }

    func notifyAdd(tasks: [Task]) {
        for observer in observers {
            observer?.source(self, didAdd: tasks)
        }
    }

    func notifyUpdate(updates: [Task]) {
        for observer in observers {
            observer?.source(self, didUpdate: updates)
        }
    }

    func notifyRemove(ids: [EntityId]) {
        for observer in observers {
            observer?.source(self, didRemove: ids)
        }
    }
}

public extension TaskSource {
    func find(by id: EntityId) -> Task? {
        return allTasks.first(where: { $0.id == id })
    }
}
