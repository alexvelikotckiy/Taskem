//
//  SignUpPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class SignUpPresenterTestCaseBase: TaskemTestCaseBase {

    fileprivate var presenter: SignUpPresenter!
    
    fileprivate var viewSpy: SignUpViewSpy!
    fileprivate var routerSpy: SignUpRouterSpy!
    fileprivate var interactorSpy: SignUpInteractorSpy!
    
    override func setUp() {
        super.setUp()
        
        viewSpy = .init()
        routerSpy = .init()
        interactorSpy = .init()
        presenter = SignUpPresenter(view: viewSpy, router: routerSpy, interactor: interactorSpy)
    }

    fileprivate func expectSpinner(_ isVisible: Bool, line: UInt = #line) {
        expect(isVisible, line: line) == viewSpy.isVisibleSpinner
    }
}

class SignUpPresenterTestCase: SignUpPresenterTestCaseBase {
    
    func testShouldPostErrorIfIncorrectName() {
        presenter.onTouchSignUp(name: "1QWERTY", email: "", password: "")
        presenter.onTouchSignUp(name: "123456", email: "", password: "")
        presenter.onTouchSignUp(name: "UserName-\\/!@$%", email: "", password: "")
        
        expect(self.viewSpy.postNameFailureCount) == 3
    }
    
    func testShouldProcessSignUp() {
        presenter.onTouchSignUp(name: "UserName", email: "mail@mail.com", password: "123456")
        
        expect(self.interactorSpy.signUpWithBeanCalled).toNot(beNil())
        expectSpinner(true)
    }
    
    func testShouldDismiss() {
        presenter.onTouchCancel()
        
        expect(self.routerSpy.didDismiss) == true
    }
    
    func testNavigateToSignIn() {
        presenter.onTouchNavigateToSignIn()
        
        expect(self.routerSpy.didNavigateToSignIn) == true
    }
}

class SignUpPresenterInteractorOutputTestCase: SignUpPresenterTestCaseBase {
    
    override func setUp() {
        super.setUp()
        
        viewSpy.displaySpinner(true)
    }
    
    func testNavigateToTeplateSetupOnSuccessUserSignUp() {
        let newUser = UserSourceStub.newUserStub()
        
        presenter.signupInteractorDidSignUp(SignUpInteractorDummy(), newUser)
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentTemplatesSetup) == true
    }
    
    func testPresentAlertOnFailSignUp() {
        presenter.signupInteractorFailSignUp(SignUpInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.routerSpy.didPresentAlert) == true
    }
    
    func testPresentAlertOnIncorrentEmailSignUp() {
        presenter.signupInteractorFailSignUpEmail(SignUpInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.viewSpy.postEmailFailureCount) == 1
    }
    
    func testPresentAlertOnIncorrentPassSignUp() {
        presenter.signupInteractorFailSignUpPass(SignUpInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.viewSpy.postPasswordFailureCount) == 1
    }
}
