//
//  TaskSourceIntercatorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class TaskSourceIntercatorTestCase: XCTestCase {

    var interactor: TaskSourceInteractorDummy!
    
    var interactorSpy: TaskSourceInteractorObserverSpy!
    var sourceSpy: TaskSourceSpy!
    
    var factoryTasks: TaskFactory!
    
    override func setUp() {
        super.setUp()
        
        factoryTasks = .init()
        let taskOne = factoryTasks.make { $0.idGroup = "group_id_1" }
        let taskTwo = factoryTasks.make { $0.idGroup = "group_id_2" }
        
        sourceSpy = .init([taskOne, taskTwo])
        
        interactorSpy = .init()
        interactor = .init(sourceTasks: sourceSpy)
        interactor.delegate = interactorSpy
    }
    
    func testShouldNotifyOnChangeSourceState() {
        sourceSpy.state = .loading

        interactor.sourceDidChangeState(sourceSpy)

        expect(self.interactorSpy.lastState) == .loading
    }
    
    func testShouldNotifyOnAdd() {
        let tasks = sourceSpy.allTasks

        interactor.source(sourceSpy, didAdd: tasks)

        expect(self.interactorSpy.added) == tasks
    }
    
    func testShouldNotifyOnUpdate() {
        let tasks = sourceSpy.allTasks
        
        interactor.source(sourceSpy, didUpdate: tasks)
        
        expect(self.interactorSpy.updated) == tasks
    }
    
    func testShouldNotifyOnRemove() {
        let ids = sourceSpy.allTasks.map { $0.id }
        
        interactor.source(sourceSpy, didRemove: ids)

        expect(self.interactorSpy.removed) == ids
    }
    
    func testShouldAddTasks() {
        let taskOne = factoryTasks.make { $0.idGroup = "group_id" }
        let taskTwo = factoryTasks.make { $0.idGroup = "group_id" }
        
        interactor.insertTasks([taskOne, taskTwo])
        
        expect(self.sourceSpy.addedTasks) == [taskOne, taskTwo]
    }
    
    func testShouldUpdateTasks() {
        let taskOne = factoryTasks.make { $0.idGroup = "group_id" }
        let taskTwo = factoryTasks.make { $0.idGroup = "group_id" }
        
        interactor.updateTasks([taskOne, taskTwo])
        
        expect(self.sourceSpy.updatedTasks) == [taskOne, taskTwo]
    }
    
    func testShouldRemoveTasks() {
        let idOne = sourceSpy.allTasks[0].id
        let idTwo = sourceSpy.allTasks[1].id
        
        interactor.removeTasks([idOne, idTwo])
        
        expect(self.sourceSpy.removedTasks) == [idOne, idTwo]
    }
    
    func testShouldFetchTasks() {
        let predicate: (Task) -> Bool = { $0.idGroup == "group_id_1" }
        
        interactor.fetchTasks(predicate) { result in
            expect(result.count) == 1
            expect(result.first!.idGroup) == "group_id_1"
        }
    }
}
