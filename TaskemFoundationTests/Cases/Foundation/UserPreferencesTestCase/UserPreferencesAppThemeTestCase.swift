//
//  UserPreferencesAppThemeTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesAppThemeTestCase: UserPreferencesTestCaseBase {
    
    private let themeKey = "\(UserPreferencesTestCaseBase.rootKey):theme"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.theme) == .light
    }
    
    func testShouldSaveValue() {
        preferences.theme = .dark
        
        expect(self.defaultsDouble.string(forKey: self.themeKey)) == "dark"
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldBeDefaultIfInvalidFormat() {
        defaultsDouble.set("?", forKey: themeKey)
        
        expect(self.preferences.theme) == .light
    }
    
    func testNotifyChangeAppTheme() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .UserPreferencesDidChangeAppTheme,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )
        
        preferences.theme = .dark
        
        expect(notificationWasPosted).to(beTrue(), description: "No notification")
        
        NotificationCenter.default.removeObserver(observer)
    }
    
}
