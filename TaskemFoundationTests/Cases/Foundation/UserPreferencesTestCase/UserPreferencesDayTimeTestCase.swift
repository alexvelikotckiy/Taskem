//
//  UserPrefencesDayTimeTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesMorningScheduleTestCase: UserPreferencesTestCaseBase {
    private let morningKey = "\(UserPreferencesTestCaseBase.rootKey):morning"
    private let defaultValue = DayTime(hour: 8, minute: 0)
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.morning) == defaultValue
    }
    
    func testShouldSaveValue() {
        let expected = DayTime(hour: 9, minute: 0)
        
        preferences.morning = expected
        
        expect(self.preferences.morning) == expected
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldGetValue() {
        defaultsDouble.set(["value": 65], forKey: morningKey)
        
        expect(self.preferences.morning) == .init(hour: 1, minute: 5)
    }
    
    func testShouldBeDefaultIfInvalidFormat() {
        defaultsDouble.set(["value_": 65], forKey: morningKey)
        
        expect(self.preferences.morning) == defaultValue
    }
}

class UserPreferencesNoonScheduleTestCase: UserPreferencesTestCaseBase {
    private let noonKey = "\(UserPreferencesTestCaseBase.rootKey):noon"
    private let defaultValue = DayTime(hour: 12, minute: 0)
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.noon) == defaultValue
    }
    
    func testShouldSaveValue() {
        let expected = DayTime(hour: 13, minute: 0)
        
        preferences.noon = expected
        
        expect(self.preferences.noon) == expected
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldGetValue() {
        defaultsDouble.set(["value": 65], forKey: noonKey)
        
        expect(self.preferences.noon) == .init(hour: 1, minute: 5)
    }
    
    func testShouldBeDefaultIfInvalidFormat() {
        defaultsDouble.set(["value_": 65], forKey: noonKey)
        
        expect(self.preferences.noon) == defaultValue
    }
}

class UserPreferencesEveningScheduleTestCase: UserPreferencesTestCaseBase {
    private let eveningKey = "\(UserPreferencesTestCaseBase.rootKey):evening"
    private let defaultValue = DayTime(hour: 18, minute: 0)
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.evening) == defaultValue
    }
    
    func testShouldSaveValue() {
        let expected = DayTime(hour: 9, minute: 0)
        
        preferences.evening = expected
        
        expect(self.preferences.evening) == expected
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldGetValue() {
        defaultsDouble.set(["value": 65], forKey: eveningKey)
        
        expect(self.preferences.evening) == .init(hour: 1, minute: 5)
    }
    
    func testShouldBeDefaultIfInvalidFormat() {
        defaultsDouble.set(["value_": 65], forKey: eveningKey)
        
        expect(self.preferences.evening) == defaultValue
    }
}
