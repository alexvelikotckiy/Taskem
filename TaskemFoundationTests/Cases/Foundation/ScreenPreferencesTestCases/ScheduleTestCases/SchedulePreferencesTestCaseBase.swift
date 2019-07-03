//
//  SchedulePreferencesTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SchedulePreferencesTestCaseBase: XCTestCase {

    var preferences: SystemSchedulePreferences!
    var defaultsDouble: UserDefaultsDouble!
    let defaultsSuiteName = "\(SchedulePreferencesTestCaseBase.self)"
    
    static let rootKey = "com.wilson.taskemFoundation.SchedulePreferences"
    
    override func setUp() {
        super.setUp()
        
        preferences = SystemSchedulePreferences()
        defaultsDouble = UserDefaultsDouble(suiteName: defaultsSuiteName)
        defaultsDouble.resetDefaults()
        preferences.defaults = defaultsDouble
    }

    override func tearDown() {
        defaultsDouble.resetDefaults()
        
        super.tearDown()
    }
}
