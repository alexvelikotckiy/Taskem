//
//  GroupSourceObserversTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class GroupSourceObserversTestCase: XCTestCase {

    private var observerSpyOne: GroupSourceObserverSpy!
    private var observerSpyTwo: GroupSourceObserverSpy!
    private var source: GroupSourceWithObserversStub!
    
    private let factory: GroupFactory = .init()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        observerSpyOne = GroupSourceObserverSpy()
        observerSpyTwo = GroupSourceObserverSpy()
        source = GroupSourceWithObserversStub(observers: [])
        source.addObserver(observerSpyOne)
        source.addObserver(observerSpyTwo)
    }

    func testShouldRemoveObserver() {
        source.removeObserver(observerSpyOne)
        
        expect(self.source.observers.count).to(equal(1))
        expect(self.source.observers.first).to(be(observerSpyTwo))
    }
    
    func testShouldNotifyChangeState() {
        source.setState(.loading)
        
        source.notifyDidChangeState()
        
        expect(self.observerSpyOne.lastGroupsStateChange).to(equal(.loading))
        expect(self.observerSpyTwo.lastGroupsStateChange).to(equal(.loading))
    }
    
    func testShouldNotifyAddGroup() {
        let group = factory.make()
        
        source.notifyAdd(groups: [group])
        
        expect(self.observerSpyOne.addedGroups.count).to(equal(1))
        expect(self.observerSpyTwo.addedGroups.count).to(equal(1))
        expect(self.observerSpyOne.addedGroups[0].id).to(equal(group.id))
        expect(self.observerSpyTwo.addedGroups[0].id).to(equal(group.id))
    }
    
    func testShouldNotifyUpdate() {
        let group = factory.make()
        
        source.notifyUpdate(updates: [group])
        
        expect(self.observerSpyOne.updatedGroups.count).to(equal(1))
        expect(self.observerSpyTwo.updatedGroups.count).to(equal(1))
        expect(self.observerSpyOne.updatedGroups[0].id).to(equal(group.id))
        expect(self.observerSpyTwo.updatedGroups[0].id).to(equal(group.id))
    }
    
    func testShouldNotifyRemove() {
        let id = EntityId.auto()
        
        source.notifyRemove(ids: [id])
        
        expect(self.observerSpyOne.removedGroups.count).to(equal(1))
        expect(self.observerSpyTwo.removedGroups.count).to(equal(1))
        expect(self.observerSpyOne.removedGroups[0]).to(equal(id))
        expect(self.observerSpyTwo.removedGroups[0]).to(equal(id))
    }
    
    func testShouldNotifyUpdateOrder() {
        let idOne = EntityId.auto()
        let idTwo = EntityId.auto()
        
        source.notifyUpdateOrder(ids: [idOne, idTwo])
        
        expect(self.observerSpyOne.orderSequenceUpdate.count).to(equal(2))
        expect(self.observerSpyTwo.orderSequenceUpdate.count).to(equal(2))
        expect(self.observerSpyOne.orderSequenceUpdate[0]).to(equal(idOne))
        expect(self.observerSpyTwo.orderSequenceUpdate[0]).to(equal(idOne))
        expect(self.observerSpyOne.orderSequenceUpdate[1]).to(equal(idTwo))
        expect(self.observerSpyTwo.orderSequenceUpdate[1]).to(equal(idTwo))
    }
}
