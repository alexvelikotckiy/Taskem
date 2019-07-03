//
//  FirebaseGroupSource.swift
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

private let keyRefGroupsInfo = "info"
private let keyRefGroupsData = "data"

private let keyRefGroupsOrder = "order"
private let keyRefGroupsDefault = "defaultGroup"

internal var refGroupsCurrentUser: DatabaseReference? {
    guard let userId = Auth.auth().currentUser?.uid else { return nil }
    return refGroups.child(userId)
}

internal var refGroupsInfo: DatabaseReference? {
    return refGroupsCurrentUser?.child("/\(keyRefGroupsInfo)/")
}

internal var refGroupsData: DatabaseReference? {
    return refGroupsCurrentUser?.child("/\(keyRefGroupsData)/")
}

public class FirebaseGroupSource: GroupSource {
    
    public var observers: ObserverCollection<GroupSourceObserver> = .init()
    public var allGroups: [Group] = []
    
    public var info: GroupsInfo = .init()
    
    internal var sourceUser: UserService

    private let coder: _FirebaseGroupCoder = .init()
    
    public var state: DataState = .notLoaded {
        didSet {
            DispatchQueue.main.async {
                self.notifyDidChangeState()
            }
        }
    }
    
    public init(sourceUser: UserService) {
        self.sourceUser = sourceUser
    }

    private func removeDatabaseObervers() {
        refGroups.removeAllObservers()
        refGroupsData?.removeAllObservers()
        refGroupsInfo?.removeAllObservers()
    }

    private func observeDatabaseChanges() {
        weak var weakSelf = self

        refGroupsInfo?.observe(.value) { snapshot in
            guard let strongSelf = weakSelf,
                let info: GroupsInfo = strongSelf.coder.decode(snapshot) else { return }

            if info.defaultGroup != strongSelf.info.defaultGroup {
                let oldInfo = strongSelf.info
                strongSelf.info.defaultGroup = info.defaultGroup
                strongSelf.reloadDefaultGroup(update: .make(new: info, old: oldInfo))
            }
            if info.order != strongSelf.info.order {
                strongSelf.info.order = info.order
                strongSelf.notifyUpdateOrder(ids: info.order)
            }
        }

        refGroupsData?.observe(.childAdded) { snapshot in
            guard let strongSelf = weakSelf,
                strongSelf.state == .loaded,
                var added: Group = strongSelf.coder.decode(snapshot) else { return }
            added.isDefault = strongSelf.info.defaultGroup == added.id

            if let index = strongSelf.allGroups.firstIndex(where: { $0.id == added.id }) {
                strongSelf.allGroups[index] = added
                strongSelf.notifyUpdate(updates: [added])
            } else {
                strongSelf.allGroups.append(added)
                strongSelf.notifyAdd(groups: [added])
            }
        }

        refGroupsData?.observe(.childChanged) { snapshot in
            guard let strongSelf = weakSelf,
                var updated: Group = strongSelf.coder.decode(snapshot),
                let index = strongSelf.allGroups.firstIndex(where: { $0.id == updated.id }) else { return }
            updated.isDefault = strongSelf.info.defaultGroup == updated.id

            strongSelf.allGroups[index] = updated
            strongSelf.notifyUpdate(updates: [updated])
        }

        refGroupsData?.observe(.childRemoved) { snapshot in
            guard let strongSelf = weakSelf else { return }
            let removed = snapshot.key
            strongSelf.allGroups = strongSelf.allGroups.filter { !removed.contains($0.id) }
            strongSelf.notifyRemove(ids: [removed])
        }
    }

    private func reloadDefaultGroup(update: Update<GroupsInfo>) {
        guard let old = allGroups.firstIndex(where: { $0.id == update.old.defaultGroup }),
            let new = allGroups.firstIndex(where: { $0.id == update.new.defaultGroup }) else { return }

        allGroups[old].isDefault = false
        allGroups[new].isDefault = true
        notifyUpdate(updates: [allGroups[old], allGroups[new]])
    }

    private func reloadAll() {
        state = .loading
        refGroupsCurrentUser?.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let strongSelf = self else { return }
            let infoSnapshot = snapshot.childSnapshot(forPath: keyRefGroupsInfo)
            let dataSnapshot = snapshot.childSnapshot(forPath: keyRefGroupsData)
            
            guard let info: GroupsInfo = strongSelf.coder.decode(infoSnapshot) else { return }
            
            strongSelf.info = info
            strongSelf.allGroups = strongSelf.generateAndOrderArray(dataSnapshot, info: info)
            
            strongSelf.state = .loaded
        }
    }

    private func generateAndOrderArray(_ snapshot: DataSnapshot, info: GroupsInfo) -> [Group] {
        let groups: [Group] = snapshot.children.reduce(into: []) { result, child in
            guard let data = child as? DataSnapshot,
                var group: Group = coder.decode(data) else { return }
            
            group.isDefault = info.defaultGroup == group.id
            result.append(group)
        }
        
        return info.order.reduce(into: []) { result, id in
            if let next = groups.first(where: { $0.id == id }) {
                result.append(next)
            }
        }
    }

    public func start() {
        allGroups.removeAll()
        sourceUser.addObserver(self)
        observeDatabaseChanges()
        reloadAll()
    }

    public func stop() {
        allGroups.removeAll()
        state = .notLoaded
        sourceUser.removeObserver(self)
        removeDatabaseObervers()
    }

    public func restart() {
        allGroups.removeAll()
        removeDatabaseObervers()
        observeDatabaseChanges()
        reloadAll()
    }

    public func setDefalut(byId: EntityId) {
        let data = [keyRefGroupsDefault: byId]
        refGroupsInfo?.updateChildValues(data)
    }
    
    public func update(groups: [Group]) {
        let data = coder.encode(groups, info: info)
        refGroupsCurrentUser?.updateChildValues(data)
    }

    public func add(groups: [Group]) {
        info.append(ids: groups.map { $0.id })
        
        let data = coder.encode(groups, info: info)
        refGroupsCurrentUser?.updateChildValues(data)
    }

    public func remove(byIds: [EntityId]) {
        info.remove(ids: byIds)
        
        let data = coder.encodeEmpty(byIds, info: info)
        refGroupsCurrentUser?.updateChildValues(data)
    }
    
    public func reorder(byId: EntityId, source: Int, destination: Int) {
        info.replace(id: byId, to: destination)
        
        let data = [keyRefGroupsOrder: info.order]
        refGroupsInfo?.updateChildValues(data)
    }
}

extension FirebaseGroupSource: UserObserver {
    public func didUpdateUser(_ user: User?) {
        removeDatabaseObervers()
        observeDatabaseChanges()
        reloadAll()
    }
}

fileprivate class _FirebaseGroupCoder: _FirebaseEncoder, _FirebaseDecoder {
    func encodeEmpty(_ ids: [EntityId], info: GroupsInfo) -> [String: Any] {
        var data: [String : Any] = ids.reduce(into: [:]) {
            $0["/\(keyRefGroupsData)/\($1)/"] = NSNull()
        }
        data[keyRefGroupsInfo] = encode(info)
        return data
    }
    
    func encode(_ groups: [Group], info: GroupsInfo) -> [String: Any] {
        var data: [String : Any] = groups.reduce(into: [:]) { result, group in
            if let data = encode(group) {
                result["/\(keyRefGroupsData)/\(group.id)/"] = data
            }
        }
        data[keyRefGroupsInfo] = encode(info)
        return data
    }
}
