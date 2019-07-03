//
//  GroupPopupInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/27/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class GroupPopupInteractorTestCase: TaskemTestCaseBase {

    private var interactor: GroupPopupDefaultInteractor!
    
    // Test Doubles
    private var spySourceGroups: GroupSourceSpy!
    
    override func setUp() {
        super.setUp()
        
        spySourceGroups = .init()
        
        interactor = .init(sourceGroups: spySourceGroups)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldBeGroupInteractor() {
        expect(self.interactor).to(beAKindOf(GroupSourceInteractor.self))
    }

    func testShouldAddObservers() {
        interactor.start()
        
        expect(self.spySourceGroups.observers.count) == 1
        expect(self.spySourceGroups.observers.first) === interactor
    }

    func testShouldRemoveObserver() {
        interactor.start()
        interactor.stop()
        
        expect(self.spySourceGroups.observers.count) == 0
    }
    
    func testShouldRestartObservers() {
        interactor.start()
        interactor.restart()
        
        expect(self.spySourceGroups.wasRestartCalled).toEventually(beTrue())
    }
}
