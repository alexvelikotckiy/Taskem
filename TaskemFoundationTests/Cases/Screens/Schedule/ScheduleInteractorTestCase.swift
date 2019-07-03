//
//  ScheduleInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleInteractorTestCase: ScheduleTestCaseBase {

    var interactor: ScheduleDefaultInteractor!
    
    var spySourceTasks: TaskSourceSpy!
    var spySourceGroups: GroupSourceSpy!
    var spyShareService: SharingServiceSpy!
    
    override func setUp() {
        super.setUp()
        
        spySourceTasks = .init()
        spySourceGroups = .init()
        spyShareService = .init()
        
        interactor = .init(sourceTasks: spySourceTasks, sourceGroups: spySourceGroups, shareService: spyShareService)
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

        expect(self.spySourceGroups.wasRestartCalled).toEventually(beTrue())
    }
    
    func testShouldShare() {
        let task = TaskFactory().make { $0.name = "Task to share" }
        let expectedText = spyShareService.createShareText(from: [task])
        
        interactor.shareTasks([task])
        
        expect(self.spyShareService.lastSharedText) == expectedText
    }
}
