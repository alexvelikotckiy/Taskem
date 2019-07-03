//
//  FirebaseTaskSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import TaskemFoundation
import CodableFirebase

internal var refTasksCurrentUser: DatabaseReference? {
    guard let userId = Auth.auth().currentUser?.uid else { return nil }
    return refTasks.child(userId)
}

public class FirebaseTaskSource: TaskSource {
    
    public var observers: ObserverCollection<TaskSourceObserver> = .init()
    public var allTasks: [Task] = []
    
    public var state: DataState = .notLoaded {
        didSet {
            DispatchQueue.main.async {
                self.notifyDidChangeState()
            }
        }
    }

    internal var sourceGroups: GroupSource
    internal var sourceUser: UserService
    
    private let coder: _FirebaseTaskCoder = .init()
    
    public init(sourceUser: UserService,
                sourceGroups: GroupSource) {
        self.sourceGroups = sourceGroups
        self.sourceUser = sourceUser
    }

    deinit {
        stop()
    }
    
    private func removeDatabaseObervers() {
        refTasksCurrentUser?.removeAllObservers()
    }

    private func observeDatabaseChanges() {
        weak var weakSelf = self

        refTasksCurrentUser?.observe(.childAdded) { snapshot in
            guard let strongSelf = weakSelf,
                strongSelf.state == .loaded,
                let added: Task = strongSelf.coder.decode(snapshot) else { return }
            
            if let index = strongSelf.allTasks.firstIndex(where: { $0.id == added.id }) {
                strongSelf.allTasks[index] = added
                strongSelf.notifyUpdate(updates: [added])
            } else {
                strongSelf.allTasks.append(added)
                strongSelf.notifyAdd(tasks: [added])
            }
        }

        refTasksCurrentUser?.observe(.childChanged) { snapshot in
            guard let strongSelf = weakSelf,
                let updated: Task = strongSelf.coder.decode(snapshot),
                let index = strongSelf.allTasks.firstIndex(where: { $0.id == updated.id }) else { return }
            strongSelf.allTasks[index] = updated
            strongSelf.notifyUpdate(updates: [updated])
        }

        refTasksCurrentUser?.observe(.childRemoved) { snapshot in
            guard let strongSelf = weakSelf else { return }
            strongSelf.allTasks = strongSelf.allTasks.filter { snapshot.key != $0.id }
            strongSelf.notifyRemove(ids: [snapshot.key])
        }
    }

    private func reloadAll() {
        guard isGroupSourceLoaded else { return }
        
        state = .loading
        refTasksCurrentUser?.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else { return }
            strongSelf.allTasks = snapshot.children.reduce(into: []) { result, child in
                if let data = child as? DataSnapshot,
                    let task: Task = strongSelf.coder.decode(data) {
                    result.append(task)
                }
            }
            strongSelf.state = .loaded
        }
    }

    public func start() {
        DispatchQueue.global().async {
            self.allTasks.removeAll()
            self.sourceUser.addObserver(self)
            self.sourceGroups.addObserver(self)
            self.reloadAll()
            self.observeDatabaseChanges()
        }
    }

    public func stop() {
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async(group: dispatchGroup) {
            self.allTasks.removeAll()
            self.sourceUser.removeObserver(self)
            self.sourceGroups.removeObserver(self)
            self.removeDatabaseObervers()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.state = .notLoaded
        }
    }
    
    public func restart() {
        allTasks.removeAll()
        removeDatabaseObervers()
        reloadAll()
        observeDatabaseChanges()
    }

    public func add(tasks: [Task]) {
        let data = coder.encode(tasks)
        refTasksCurrentUser?.updateChildValues(data)
    }

    public func update(tasks: [Task]) {
        let data = coder.encode(tasks)
        refTasksCurrentUser?.updateChildValues(data)
    }

    public func remove(byIds: [EntityId]) {
        let data = coder.encodeEmpty(byIds)
        refTasksCurrentUser?.updateChildValues(data)
    }
    
    private var isGroupSourceLoaded: Bool {
        return sourceGroups.state == .loaded
    }
}

extension FirebaseTaskSource: GroupSourceObserver {
    public func sourceDidChangeState(_ source: GroupSource) {
        switch source.state {
        case .loaded:
            reloadAll()
        default:
            break
        }
    }
    
    public func source(_ source: GroupSource, didAdd groups: [Group]) {
        
    }
    
    public func source(_ source: GroupSource, didUpdate groups: [Group]) {
        let updated = allTasks.filter { groups.map { $0.id }.contains($0.idGroup) }
        notifyUpdate(updates: updated)
    }
    
    public func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        let data = coder.encodeEmpty(allTasks.filter { ids.contains($0.idGroup) }.map { $0.id })
        refTasksCurrentUser?.updateChildValues(data)
    }
    
    public func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        
    }
}

extension FirebaseTaskSource: UserObserver {
    public func didUpdateUser(_ user: User?) {
        removeDatabaseObervers()
        observeDatabaseChanges()
        reloadAll()
    }
}

internal class _FirebaseTaskCoder: _FirebaseEncoder, _FirebaseDecoder {
    func encodeEmpty(_ ids: [EntityId]) -> [String: Any] {
        return ids.reduce(into: [:]) {
            $0["/\($1)/"] = NSNull()
        }
    }
    
    func encode(_ tasks: [Task]) -> [String: Any] {
        return tasks.reduce(into: [:]) { result, task in
            if let data = encode(task) {
                result["/\(task.id)/"] = data
            }
        }
    }
}
