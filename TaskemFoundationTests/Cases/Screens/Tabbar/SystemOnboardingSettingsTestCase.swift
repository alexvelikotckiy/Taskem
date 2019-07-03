//
//  SystemOnboardingSettingsTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SystemOnboardingSettingsTestCase: XCTestCase {
    
    var userDefaultsDouble: UserDefaultsDouble!
    var onboardingSettings: SystemOnboardingSettings!
    
    override func setUp() {
        super.setUp()
        
        userDefaultsDouble = UserDefaultsDouble(suiteName: "\(SystemOnboardingSettingsTestCase.self)")
        onboardingSettings = SystemOnboardingSettings()
        userDefaultsDouble.resetDefaults()
        onboardingSettings.userDefaults = userDefaultsDouble
    }
    
    override func tearDown() {
        userDefaultsDouble.resetDefaults()
        
        super.tearDown()
    }
    
    func testShouldHaveStandardUserDefaultsByDefault() {
        expect(SystemOnboardingSettings().userDefaults).to(be(UserDefaults.standard))
    }
    
    func testOnboardingScreenWasNotShownIfDataIsMissing() {
        expect(self.onboardingSettings.onboardingScreenWasShown).to(beFalse())
    }
    
    func testShouldStoreValue() {
        onboardingSettings.onboardingScreenWasShown = true
        onboardingSettings.onboardingDefaultDataWasChoose = true
        
        expectSetValue(true, key: onboardingSettings.keyOnboardingScreenWasShown)
        expectSetValue(true, key: onboardingSettings.keyOnboardingDefaultDataWasChoose)
    }
    
    private func expectSetValue(_ flag: Bool, key: String, line: UInt = #line) {
        expect(self.userDefaultsDouble.bool(forKey: key), line: line).to(equal(flag))
        expect(self.userDefaultsDouble.synchornizedWasCalled, line: line).to(beTrue(), description: "Expected to sync data.")
    }
    
}
