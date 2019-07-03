//
//  LogInPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class LogInPresenterTestCaseBase: TaskemTestCaseBase {
    
    fileprivate var presenter: LogInPresenter!
    
    fileprivate var viewSpy: LogInViewSpy!
    fileprivate var routerSpy: LogInRouterSpy!
    fileprivate var interactorSpy: LogInInteractorMock!
    
    override func setUp() {
        super.setUp()
        
        viewSpy = .init()
        routerSpy = .init()
        interactorSpy = .init()
        presenter = .init(view: viewSpy, router: routerSpy, interactor: interactorSpy)
        presenter.onboardingSettings = OnboardingSettingsStub()
    }
    
    fileprivate func expectCancelOnboardingButTemplatesSetup(line: UInt = #line) {
        expect(self.presenter.onboardingSettings.onboardingScreenWasShown, line: line) == true
        expect(self.presenter.onboardingSettings.onboardingDefaultDataWasChoose, line: line) == false
    }
    
    fileprivate func expectCancelOnboarding(line: UInt = #line) {
        expect(self.presenter.onboardingSettings.onboardingScreenWasShown, line: line) == true
        expect(self.presenter.onboardingSettings.onboardingDefaultDataWasChoose, line: line) == true
    }
    
    fileprivate func expectSpinner(_ isVisible: Bool, line: UInt = #line) {
        expect(isVisible, line: line) == viewSpy.isVisibleSpinner
    }
}

class LogInPresenterTestCase: LogInPresenterTestCaseBase {

    func testShouldDisplayViewModelOnLoad() {
        presenter.onViewWillAppear()
        
        expect(self.viewSpy.didDisplayViewModel) == true
    }
    
    func testShouldCancelOnboardingWhenUserNotNil() {
        interactorSpy.user = UserSourceStub.anonymousUserStub()
        
        presenter.onViewWillAppear()
        
        expectCancelOnboarding()
    }
    
    func testNavigateToSignUp() {
        presenter.onTouchSignUp()
        
        expect(self.routerSpy.didPresentEmailSignUp) == true
    }
    
    func testNavigateToSignIn() {
        presenter.onTouchSignIn()
        
        expect(self.routerSpy.didPresentSignIn) == true
    }
    
    func testShouldProcessAnonymousSignInWhenUserIsNil() {
        interactorSpy.user = nil
        
        presenter.onTouchAnonymousSignIn()
        
        expectSpinner(true)
        expect(self.interactorSpy.wasSignInAnonymouslyCalled) == true
    }
    
    func testShouldDismissAnonymousSignInWhenUserNotNil() {
        interactorSpy.user = UserSourceStub.anonymousUserStub()
        
        presenter.onTouchAnonymousSignIn()
        
        expect(self.routerSpy.didDismiss) == true
    }
}

class LogInPresenterInteractorOutputTestCase: LogInPresenterTestCaseBase {
    func testNavigateToTeplateSetupOnSuccessUserAuthWithNewGoogleUser() {
        let newUser = UserSourceStub.newUserStub()
        
        presenter.loginIteractorDidSignInGoogle(LogInInteractorDummy(), newUser)
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentTemplatesSetup) == true
        expectCancelOnboardingButTemplatesSetup()
    }
    
    func testNavigateToTeplateSetupOnSuccessUserAuthWithNewAnonymousUser() {
        let newUser = UserSourceStub.newUserStub()

        presenter.loginIteractorDidSignInAnonymously(LogInInteractorDummy(), newUser)
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentTemplatesSetup) == true
        expectCancelOnboardingButTemplatesSetup()
    }
    
    func testPresentAlertOnFailAnonymousUserAuth() {
        presenter.loginIteractorFailSignInAnonymously(LogInInteractorDummy(), didFailSignInAnonymously: "Error message")
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentAlert)  == true
    }
    
    func testPresentAlertOnFailGoogleUserAuth() {
        presenter.loginIteractorFailSignInGoogle(LogInInteractorDummy(), didFailSignIn: "Error message")
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentAlert)  == true
    }
}
