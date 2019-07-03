//
//  ScheduleUserInteractionTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleUserInteractionTestCase: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleViewModelStub()
    }

    func testNavigateToTaskCreationOnTap() {
        spySourceGroups.allGroups = [GroupFactory().make { $0.isDefault = true }]
        
        presenter.onTouchPlus(isLongTap: false)
        
        expect(self.spyRouter.invokedPresentTaskPopup) == true
    }
    
    func testNavigateToTaskCreationOnLongTap() {
        spySourceGroups.allGroups = [GroupFactory().make { $0.isDefault = true }]
        
        presenter.onTouchPlus(isLongTap: true)
        
        expect(self.spyRouter.invokedPresentTask) == true
    }
    
    func testNavigateToScheduleControl() {
        presenter.onTouchScheduleControl()
        
        expect(self.spyRouter.invokedPresentScheduleControl) == true
    }
    
    func testNavigateToTaskOverview() {
        presenter.onTouch(at: .init(row: 0, section: 0), frame: .init())
        
        expect(self.spyRouter.invokedPresentTask) == true
    }
    
    func testSetTableType() {
        presenter.onChangeSorting(.flat)
        
        expect(self.schedulePreferences.typePreference) == .flat
    }
    
    func testRefresh() {
        presenter.onRefresh()
        
        expect(self.spyInteractor.didRestartCall) == 1
    }
}
