//
//  ScheduleTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/19/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class ScheduleTestCaseBase: TaskemTestCaseBase {
    
    var stubFactory: ScheduleViewModelStubFactory = .init()
    
    var schedulePreferences: SchedulePreferencesStub!
    
    override func setUp() {
        super.setUp()
        
        schedulePreferences = .init()
        SchedulePreferences.current = schedulePreferences
    }
    
    override func tearDown() {
        UserPreferences.resetCurrent()
        
        super.tearDown()
    }
}
