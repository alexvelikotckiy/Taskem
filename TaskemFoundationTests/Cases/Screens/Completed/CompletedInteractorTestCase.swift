//
//  CompletedInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CompletedInteractorTestCase: XCTestCase {

    var interactor: CompletedDefaultInteractor!
    
    var spySourceTasks: TaskSourceSpy!
    var spySourceGroups: GroupSourceSpy!
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks = .init()
        spySourceGroups = .init()
        
        interactor = CompletedDefaultInteractor(sourceTasks: spySourceTasks, sourceGroups: spySourceGroups)
    }

    func testShouldBeTaskModelInteractor() {
        expect(self.interactor).to(beAKindOf(TaskModelSourceInteractor.self))
    }
    
    func testShouldAddObservers() {
        interactor.start()
        
        expect(self.spySourceTasks.observers.count) == 1
        expect(self.spySourceTasks.observers.first) === interactor
        expect(self.spySourceGroups.observers.count) == 1
        expect(self.spySourceGroups.observers.first) === interactor
    }
    
    func testShouldRemoveObserver() {
        interactor.start()
        interactor.stop()
        
        expect(self.spySourceTasks.observers.count) == 0
        expect(self.spySourceGroups.observers.count) == 0
    }
    
    func testShouldRestartObservers() {
        interactor.start()
        interactor.restart()
        
        expect(self.spySourceTasks.wasRestartCalled).toEventually(beTrue())
        expect(self.spySourceGroups.wasRestartCalled).toEventually(beTrue())
    }
}
