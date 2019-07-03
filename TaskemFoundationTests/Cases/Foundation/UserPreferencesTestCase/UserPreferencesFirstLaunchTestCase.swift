//
//  UserPreferencesFirstLaunchTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesFirstLaunchTestCase: UserPreferencesTestCaseBase {
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.isFirstLaunch) == true
    }
    
    func testShouldSetFirstLaunch() {
        preferences.isFirstLaunch = false
        
        expect(self.preferences.isFirstLaunch) == false
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }    
}
