//
//  TaskemTestCaseBase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation

class TaskemTestCaseBase: XCTestCase {
    
    var dateProvider: DateProviderStub!
    var userPreferences: UserPreferencesStub!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        userPreferences = UserPreferencesStub()
        UserPreferences.current = userPreferences
        
        dateProvider = DateProviderStub()
        DateProvider.current = dateProvider
    }
    
    override func tearDown() {
        UserPreferences.resetCurrent()
        DateProvider.resetCurrent()
        
        super.tearDown()
    }
}
