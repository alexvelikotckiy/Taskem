//
//  GroupSourceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class GroupSourceDummy: GroupSource {
    var observers: ObserverCollection<GroupSourceObserver> = .init()
    var allGroups: [Group] = []
    var info: GroupsInfo = .init()
    var state: DataState = .notLoaded
    
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

private var factory: GroupFactory = .init()

class GroupSourceMock: GroupSourceDummy {
    override init() {
        super.init()
    }
    
    init(_ groups: [Group]) {
        super.init()
        self.allGroups = groups
    }
    
    static let group_1 = factory.make {
        $0.name = id_group_1
        $0.id = id_group_1
    }
    
    static let group_2 = factory.make {
        $0.name = id_group_2
        $0.id = id_group_2
    }
    
    static let inboxDefaultGroup = factory.make {
        $0.id = "INBOX"
        $0.name = "INBOX"
        $0.isDefault = true
    }
    
    static let todoGroup = factory.make {
        $0.id = "TODO"
        $0.name = "TODO"
        $0.isDefault = false
    }
}

class GroupSourceSpy: GroupSourceMock {
    var addedGroups: [Group] = []
    var updatedGroups: [Group] = []
    var removedGroups: [EntityId] = []
    
    var lastDefaultGroup: EntityId?
    
    var lastReorderGroup: EntityId?
    var lastReorderSource: Int?
    var lastReorderDestination: Int?
    
    var wasStartCalled = false
    var wasRestartCalled = false
    var wasStopCalled = false
    
    override func add(groups: [Group]) {
        super.add(groups: groups)
        
        addedGroups.append(contentsOf: groups)
    }
    
    override func update(groups: [Group]) {
        super.update(groups: groups)
        
        updatedGroups.append(contentsOf: groups)
    }
    
    override func remove(byIds: [EntityId]) {
        super.remove(byIds: byIds)
        
        removedGroups.append(contentsOf: byIds)
    }
    
    override func setDefalut(byId: EntityId) {
        super.setDefalut(byId: byId)
        
        lastDefaultGroup = byId
    }
    
    override func reorder(byId: EntityId, source: Int, destination: Int) {
        super.reorder(byId: byId, source: source, destination: destination)
        
        lastReorderGroup = byId
        lastReorderSource = source
        lastReorderDestination = destination
    }
    
    override func start() {
        super.start()
        
        wasStartCalled = true
    }
    
    override func restart() {
        super.restart()
        
        wasRestartCalled = true
    }
    
    override func stop() {
        super.stop()
        
        wasStopCalled = true
    }
    
    var lastAddedGroup: Group? {
        return addedGroups.last
    }
    
    var lastUpdatedGroup: Group? {
        return updatedGroups.last
    }
    
    var lastRemovedGroup: EntityId? {
        return removedGroups.last
    }
}
