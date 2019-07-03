//
//  UserPreferencesFirstWeekdayTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesFirstWeekdayTestCase: UserPreferencesTestCaseBase {
    
    private let firstweekdayKey = "\(UserPreferencesTestCaseBase.rootKey):firstWeekday"
    private let defaultValue = FirstWeekday.monday
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.firstWeekday) == defaultValue
    }
    
    func testShouldSaveValue() {
        let expected = FirstWeekday.sunday
        
        preferences.firstWeekday = expected
        
        expect(self.preferences.firstWeekday) == expected
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldGetValue() {
        defaultsDouble.set("sunday", forKey: firstweekdayKey)
        
        expect(self.preferences.firstWeekday) == .sunday
    }
    
    func testShouldBeDefaultIfInvalidFormat() {
        defaultsDouble.set("saturday", forKey: firstweekdayKey)

        expect(self.preferences.firstWeekday) == defaultValue
    }
    
    func testShouldNotifyChangeFirstWeekday() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .UserPreferencesDidChangeFirstWeekday,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )
        
        preferences.firstWeekday = .sunday
        
        expect(notificationWasPosted).to(beTrue(), description: "No notification")
        
        NotificationCenter.default.removeObserver(observer)
    }
}
