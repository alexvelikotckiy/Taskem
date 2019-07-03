//
//  ScheduleHeaderInteractionTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleHeaderInteractionTestCase: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleViewModelStub().mock
    }
    
    func testShouldToogleHeader() {
        presenter.onTouchToogleHeader(with: .schedule(.overdue))
        
        expect(self.schedulePreferences.scheduleUnexpanded.first!) == .overdue
        expect(self.schedulePreferences.scheduleUnexpanded.count) == 1
        expect(self.spyView.stubbedViewModel.sections[0].isExpanded) == false
    }
    
    func testAddAction() {
        presenter.onTouchHeaderAction(with: .schedule(.today))
        
        expect(self.spyRouter.invokedPresentTaskPopup) == true
    }
    
    func testDeleteAction() {
        let expectedToRemove = ScheduleCellStubs().completed().map { $0.id }
        spyRouter.stubbedAlertDeleteCompletionResult = (true, ())
        
        presenter.onTouchHeaderAction(with: .schedule(.complete))
        
        expect(self.spyRouter.invokedAlertDelete) == true
        expect(self.spySourceTasks.removedTasks) == expectedToRemove
    }

    func testRescheduleAction() {
        presenter.onTouchHeaderAction(with: .schedule(.overdue))
        
        expect(self.spyRouter.invokedPresentReschedule) == true
    }
}

class ScheduleProjectHeaderInteractionTestCase: SchedulePresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleProjectsModelStub().mock
    }
    
    func testShouldToogleHeader() {
        presenter.onTouchToogleHeader(with: .project(id_group_1))
        
        expect(self.schedulePreferences.projectsUnexpanded.first!) == id_group_1
        expect(self.schedulePreferences.projectsUnexpanded.count) == 1
        expect(self.spyView.stubbedViewModel.sections[0].isExpanded) == false
    }
    
    func testAddAction() {
        presenter.onTouchHeaderAction(with: .project(id_group_1))
        
        expect(self.spyRouter.invokedPresentTaskPopup) == true
    }
}

class ScheduleFlatHeaderInteractionTestCase: SchedulePresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleFlatModelStub().mock
    }
    
    func testShouldToogleHeader() {
        presenter.onTouchToogleHeader(with: .flat(.uncomplete))
        
        expect(self.schedulePreferences.flatUnexpanded.first!) == .uncomplete
        expect(self.schedulePreferences.flatUnexpanded.count) == 1
        expect(self.spyView.stubbedViewModel.sections[0].isExpanded) == false
    }
    
    func testDeleteAction() {
        let expectedToRemove = ScheduleCellStubs().completed().map { $0.id }
        spyRouter.stubbedAlertDeleteCompletionResult = (true, ())
        
        presenter.onTouchHeaderAction(with: .flat(.complete))
        
        expect(self.spyRouter.invokedAlertDelete) == true
        expect(self.spySourceTasks.removedTasks) == expectedToRemove
    }

    func testAddAction() {
        presenter.onTouchHeaderAction(with: .flat(.uncomplete))
        
        expect(self.spyRouter.invokedPresentTaskPopup) == true
    }
}
