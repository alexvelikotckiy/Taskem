//
//  ScheduleCellSwipeTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleCellSwipeTestCase: SchedulePresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.stubbedViewModel = ScheduleFlatModelStub()
    }
    
    let testIndexes = [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1)]
    
    func testToogleCompletionOnSwipeRight() {
        let uncompleted = spyView.stubbedViewModel[testIndexes[0]].id
        let completed = spyView.stubbedViewModel[testIndexes[1]].id
        
        presenter.onSwipeRight(at: testIndexes)
        
        expect(self.spySourceTasks.updatedTasks[0].id) == uncompleted
        expect(self.spySourceTasks.updatedTasks[1].id) == completed
        expect(self.spySourceTasks.updatedTasks[0].isComplete) == true
        expect(self.spySourceTasks.updatedTasks[1].isComplete) == false
    }
    
    func testNavigateToDatePickerOnSwipeLeft() {
        presenter.onSwipeLeft(at: testIndexes) { _ in }
        
        expect(self.spyRouter.invokedPresentDatePickerPopup) == true
    }
}
