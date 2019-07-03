//
//  PasswordResetPresenterCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class PasswordResetPresenterCaseBase: TaskemTestCaseBase {

    fileprivate var presenter: PasswordResetPresenter!
    
    fileprivate var spyView: PasswordResetViewSpy!
    fileprivate var spyRouter: PasswordResetRouterSpy!
    fileprivate var spyInteractor: PasswordResetInteractorSpy!
    
    fileprivate let initialEmail = "test@mail.com"
    
    override func setUp() {
        super.setUp()
        
        spyView = .init()
        spyRouter = .init()
        spyInteractor = .init()
        
        presenter = .init(view: spyView, router: spyRouter, interactor: spyInteractor, email: initialEmail)
    }
    
    fileprivate func expectSpinner(_ isVisible: Bool, line: UInt = #line) {
        expect(isVisible, line: line) == spyView.isVisibleSpinner
    }
}

class PasswordResetPresenterCase: PasswordResetPresenterCaseBase {
    
    func testShouldDispayInitialEmailOnLoad() {
        presenter.onViewWillAppear()
        
        expect(self.spyView.lastDisplayedViewModel?.email) == initialEmail
    }
    
    func testShouldPostErrorIfIncorrectMail() {
        presenter.onTouchReset(email: "1QWERTY")
        presenter.onTouchReset(email: "123456@.com")
        presenter.onTouchReset(email: "Mail-\\/!@$.123")

        expect(self.spyView.postEmailFailureCount) == 3
    }
    
    func testShouldProcessResetPass() {
        presenter.onTouchReset(email: initialEmail)

        expectSpinner(true)
        expect(self.spyInteractor.resetPassWithEmailCalled) == initialEmail
    }
    
    func testShouldNavigateToSignUp() {
        presenter.onTouchNavigateToSignUp()

        expect(self.spyRouter.didNavigateToSignUp) == true
    }
}

class PasswordResetPresenterInteractorOutputTestCase: PasswordResetPresenterCaseBase {
    
    override func setUp() {
        super.setUp()
        
        spyView.displaySpinner(true)
    }
    
    func testShouldAlertOnSuccesResetPass() {
        presenter.passwordresetInteractorDidSendPasswordReset(PasswordResetInteractorDummy())
        
        expectSpinner(false)
        expect(self.spyRouter.didPresentAlert) == true
    }
    
    func testPresentAlertOnFailResetPass() {
        presenter.passwordresetInteractorDidFailSendPasswordReset(PasswordResetInteractorDummy(), "Error message")
        
        expectSpinner(false)
        expect(self.spyRouter.didPresentAlert) == true
    }
    
    func testPresentAlertOnUserNotFound() {
        presenter.passwordresetInteractorDidFailSendPasswordResetUserNotFound(PasswordResetInteractorDummy(), "Error message")

        expectSpinner(false)
        expect(self.spyView.postEmailFailureCount) == 1
    }
}
