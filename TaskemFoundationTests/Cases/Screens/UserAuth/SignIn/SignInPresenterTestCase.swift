//
//  SignInPresenterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class SignInPresenterTestCaseBase: TaskemTestCaseBase {

    fileprivate var presenter: SignInPresenter!
    
    fileprivate var spyView: SignInViewSpy!
    fileprivate var spyRouter: SignInRouterSpy!
    fileprivate var spyInteractor: SignInInteractorSpy!
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init()
        
        presenter = .init(view: spyView, router: spyRouter, interactor: spyInteractor)
    }

    fileprivate func expectSpinner(_ isVisible: Bool, line: UInt = #line) {
        expect(isVisible, line: line) == spyView.isVisibleSpinner
    }
}

class SignInPresenterTestCase: SignInPresenterTestCaseBase {
    
    func testShouldPostErrorIfIncorrectMail() {
        presenter.onTouchSignIn(email: "1QWERTY", password: "")
        presenter.onTouchSignIn(email: "123456@.com", password: "")
        presenter.onTouchSignIn(email: "Mail-\\/!@$.123", password: "")
        
        expect(self.spyView.postEmailFailureCount) == 3
    }
    
    func testShouldProcessSignIn() {
        presenter.onTouchSignIn(email: "mail@mail.com", password: "123456")
        
        expect(self.spyInteractor.signInWithBeanCalled).toNot(beNil())
        expectSpinner(true)
    }
    
    func testShouldDismiss() {
        presenter.onTouchCancel()
        
        expect(self.spyRouter.didDismiss) == true
    }
    
    func testShouldNavigateToSignUp() {
        presenter.onTouchNavigateSignUp()
        
        expect(self.spyRouter.didNavigateToSignUp) == true
    }
    
    func testShouldNavigateToResetPass() {
        presenter.onTouchResetPassword(email: "")
        
        expect(self.spyRouter.didPresentPasswordReset) == true
    }
}

class SignInPresenterInteractorOutputTestCase: SignInPresenterTestCaseBase {

    override func setUp() {
        super.setUp()
        
        spyView.displaySpinner(true)
    }
    
    func testShouldDismissOnSuccessUserSignUp() {
        let user = UserSourceStub.realUserStub()

        presenter.signinInteractorDidSignIn(SignInInteractorDummy(), user)

        expectSpinner(false)
        expect(self.spyRouter.didDismiss) == true
    }
    
    func testPresentAlertOnFailSignIn() {
        presenter.signinInteractorFailSignIn(SignInInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.spyRouter.didPresentAlert) == true
    }
    
    func testPresentAlertOnUserNotFound() {
        presenter.signinInteractorFailSignInUserNotFound(SignInInteractorDummy(), "Error message")

        expectSpinner(false)
        expect(self.spyView.postFailureCount) == 1
    }
    
    func testPresentAlertOnIncorrentEmailSignIn() {
        presenter.signinInteractorFailSignInEmail(SignInInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.spyView.postEmailFailureCount) == 1
    }
    
    func testPresentAlertOnIncorrentPassSignIn() {
        presenter.signinInteractorFailSignInPass(SignInInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.spyView.postPasswordFailureCount) == 1
    }
}
