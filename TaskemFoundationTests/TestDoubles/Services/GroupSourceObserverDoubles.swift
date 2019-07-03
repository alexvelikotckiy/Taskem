//
//  GroupSourceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupSourceObserverSpy: GroupSourceObserverSpyProtocol {
    var lastGroupsStateChange: DataState = .notLoaded
    var addedGroups: [Group] = []
    var updatedGroups: [Group] = []
    var removedGroups: [EntityId] = []
    var orderSequenceUpdate: [EntityId] = []
}

class GroupSourceWithObserversStub: GroupSource {
    var observers: ObserverCollection<GroupSourceObserver> = .init()
    var allGroups: [Group] = []
    var info: GroupsInfo = .init()
    var state: DataState = .notLoaded
    
    func setState(_ state: DataState) {
        self.state = state
    }
    
    init(observers: ObserverCollection<GroupSourceObserver>) {
        self.observers = observers
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func restart() {
        
    }
    
    func reorder(byId: EntityId, source: Int, destination: Int) {
        
    }
    
    func setDefalut(byId: EntityId) {
        
    }
    
    func add(groups: [Group]) {
        
    }
    
    func update(groups: [Group]) {
        
    }
    
    func remove(byIds: [EntityId]) {
        
    }
}

protocol GroupSourceObserverSpyProtocol: GroupSourceObserver {
    var lastGroupsStateChange: DataState { get set }
    var addedGroups: [Group] { get set }
    var updatedGroups: [Group] { get set }
    var removedGroups: [EntityId] { get set }
    var orderSequenceUpdate: [EntityId] { get set }
}

extension GroupSourceObserverSpyProtocol {
    func sourceDidChangeState(_ source: GroupSource) {
        lastGroupsStateChange = source.state
    }
    
    func source(_ source: GroupSource, didAdd groups: [Group]) {
        addedGroups.append(contentsOf: groups)
    }
    
    func source(_ source: GroupSource, didUpdate groups: [Group]) {
        updatedGroups.append(contentsOf: groups)
    }
    
    func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        removedGroups.append(contentsOf: ids)
    }
    
    func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        orderSequenceUpdate.append(contentsOf: ids)
    }
}
