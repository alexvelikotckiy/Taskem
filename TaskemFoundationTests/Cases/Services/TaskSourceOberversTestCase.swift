//
//  TaskSourceOberversTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/20/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class TaskSourceOberversTestCase: XCTestCase {
    
    private var observerSpyOne: TaskSourceObserverSpy!
    private var observerSpyTwo: TaskSourceObserverSpy!
    private var source: TaskSourceWithObserversStub!
    
    private let factory: TaskFactory = .init()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        observerSpyOne = TaskSourceObserverSpy()
        observerSpyTwo = TaskSourceObserverSpy()
        source = TaskSourceWithObserversStub(observers: [])
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
        
        expect(self.observerSpyOne.lastTasksStateChange).to(equal(.loading))
        expect(self.observerSpyTwo.lastTasksStateChange).to(equal(.loading))
    }
    
    func testShouldNotifyAddTasks() {
        let task = factory.make()
        
        source.notifyAdd(tasks: [task])
        
        expect(self.observerSpyOne.addedTasks.count).to(equal(1))
        expect(self.observerSpyTwo.addedTasks.count).to(equal(1))
        expect(self.observerSpyOne.addedTasks[0].id).to(equal(task.id))
        expect(self.observerSpyTwo.addedTasks[0].id).to(equal(task.id))
    }
    
    func testShouldNotifyUpdate() {
        let task = factory.make()
        
        source.notifyUpdate(updates: [task])
        
        expect(self.observerSpyOne.updatedTasks.count).to(equal(1))
        expect(self.observerSpyTwo.updatedTasks.count).to(equal(1))
        expect(self.observerSpyOne.updatedTasks[0].id).to(equal(task.id))
        expect(self.observerSpyTwo.updatedTasks[0].id).to(equal(task.id))
    }
    
    func testShouldNotifyRemove() {
        let id = EntityId.auto()
        
        source.notifyRemove(ids: [id])
        
        expect(self.observerSpyOne.removedTasks.count).to(equal(1))
        expect(self.observerSpyTwo.removedTasks.count).to(equal(1))
        expect(self.observerSpyOne.removedTasks[0]).to(equal(id))
        expect(self.observerSpyTwo.removedTasks[0]).to(equal(id))
    }
    
}
