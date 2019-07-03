//
//  TabbarTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class TabbarTestCase: TaskemTestCaseBase {
    
    var onboardingSettingStub: OnboardingSettingsStub!
    var viewModel: TabbarViewModel!
    
    var sourceUser: UserSourceMock!
    
    var onboardingWasShown = false
    var onboardingDefaultDataWasChoose = false
    var wasTemplateSetupShown = false
    var wasUserAuthWasShown = false
    
    override func setUp() {
        super.setUp()
        
        sourceUser = .init()
        
        onboardingSettingStub = OnboardingSettingsStub()
        
        viewModel = TabbarViewModel(userService: sourceUser)
        viewModel.onboardingSettings = onboardingSettingStub
        viewModel.onShowOnboarding = { [weak self] in self?.onboardingWasShown = true }
        viewModel.onShowUserAuth = { [weak self] in self?.wasUserAuthWasShown = true }
        viewModel.onShowTemplateSetup = { [weak self] in self?.wasTemplateSetupShown = true }
    }
    
    override func tearDown() {
        super.tearDown()
        
        onboardingWasShown = false
        wasUserAuthWasShown = false
        wasTemplateSetupShown = false
        onboardingDefaultDataWasChoose = false
    }
    
    func testShouldShowOnboardingForTheFirstTime() {
        setOnboardingScreenWasNotShown()
        
        viewModel.appear()
        
        expectShowOnboarding()
        expectSettingsSetOnboardingScreenWasShown()
    }
    
    func testShouldNotShowOnboardingForTheSecondTime() {
        setOnboardingScreenWasShown()
        
        viewModel.appear()
        
        expectSettingsNotToSetOnboardingWasShown()
    }
    
    func testShouldShowTemplatesPickerIfDefaultDataWasntChoose() {
        sourceUser.user = UserSourceStub.realUserStub()
        onboardingSettingStub.onboardingDefaultDataWasChoose = false
        
        viewModel.appear()
        
        expectTemplateSetupShown()
    }
    
    func testShouldHaveDefaultOnboardingSettings() {
        let viewModel = TabbarViewModel(userService: UserSourceDummy())
        let onboardingSettings = viewModel.onboardingSettings
        
        expect(onboardingSettings).to(beAnInstanceOf(SystemOnboardingSettings.self))
    }
    
    func testShouldShowTemplatesPickerWhenUserIsNew() {
        setOnboardingScreenWasShown()
        let newUser = UserSourceStub.newUserStub()
        
        viewModel.didUpdateUser(newUser)
        
        expectTemplateSetupShown()
    }
    
    func testShouldNotShowTemplatesPickerWhenUserIsNotNew() {
        setOnboardingScreenWasShown()
        let notNewUser = UserSourceStub.realUserStub()
        
        viewModel.didUpdateUser(notNewUser)
        
        expectTemplateSetupNotShown()
    }
    
    func testShouldShowUserAuthWhenUserIsNil() {
        setOnboardingScreenWasShown()
        
        viewModel.didUpdateUser(nil)
        
        expectUserAuthWasShown()
    }
    
    func testShouldNotShowUserAuthWhenUserIsNotNil() {
        setOnboardingScreenWasShown()
        let user = UserSourceStub.realUserStub()
        
        viewModel.didUpdateUser(user)
        
        expectUserAuthWasNotShown()
    }
    
    private func setWasTemplateSetupShown() {
        onboardingSettingStub.onboardingDefaultDataWasChoose = true
    }
    
    private func setWasTemplateSetupWasNotShown() {
        onboardingSettingStub.onboardingDefaultDataWasChoose = false
    }
    
    private func setOnboardingScreenWasShown() {
        onboardingSettingStub.onboardingScreenWasShown = true
    }
    
    private func setOnboardingScreenWasNotShown() {
        onboardingSettingStub.onboardingScreenWasShown = false
    }
    
    private func expectSettingsSetOnboardingScreenWasShown(line: UInt = #line) {
        expect(self.onboardingSettingStub.onboardingScreenWasShown, line: line).to(beTrue())
    }
    
    private func expectShowOnboarding(line: UInt = #line) {
        expect(self.onboardingWasShown, line: line).to(beTrue())
    }
    
    private func expectSettingsNotToSetOnboardingWasShown(line: UInt = #line) {
        expect(self.onboardingWasShown, line: line).to(beFalse())
    }
    
    private func expectTemplateSetupShown(line: UInt = #line) {
        expect(self.wasTemplateSetupShown, line: line).to(beTrue())
    }
    
    private func expectTemplateSetupNotShown(line: UInt = #line) {
        expect(self.wasTemplateSetupShown, line: line).to(beFalse())
    }
    
    private func expectUserAuthWasShown(line: UInt = #line) {
        expect(self.wasUserAuthWasShown, line: line).to(beTrue())
    }
    
    private func expectUserAuthWasNotShown(line: UInt = #line) {
        expect(self.wasUserAuthWasShown, line: line).to(beFalse())
    }
}

class OnboardingSettingsStub: OnboardingSettings {
    var onboardingScreenWasShown: Bool = false
    var onboardingDefaultDataWasChoose: Bool = false
}
