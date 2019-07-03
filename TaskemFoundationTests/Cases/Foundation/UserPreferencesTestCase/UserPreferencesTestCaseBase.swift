//
//  UserPreferencesTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesTestCaseBase: XCTestCase {
    
    var preferences: SystemUserPreferences!
    var defaultsDouble: UserDefaultsDouble!
    let defaultsSuiteName = "\(UserPreferencesTestCaseBase.self)"
    
    static let rootKey = "com.wilson.taskemFoundation.UserPreferences"
    
    override func setUp() {
        super.setUp()
        
        preferences = SystemUserPreferences()
        defaultsDouble = UserDefaultsDouble(suiteName: defaultsSuiteName)
        defaultsDouble.resetDefaults()
        preferences.defaults = defaultsDouble
    }
    
    override func tearDown() {
        defaultsDouble.resetDefaults()
        
        super.tearDown()
    }
}
