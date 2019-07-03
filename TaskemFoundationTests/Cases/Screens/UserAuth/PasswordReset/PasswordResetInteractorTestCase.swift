//
//  PasswordResetInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class PasswordResetInteractorTestCaseBase: TaskemTestCaseBase {

    fileprivate var interactor: PasswordResetDefaultInteractor!
    fileprivate var interactorObserverSpy: PasswordResetInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
        
        interactor = .init(userService: UserSourceDummy())
        interactorObserverSpy = .init()
        interactor.delegate = interactorObserverSpy
    }
}

class PasswordResetInteractorSuccessTestCase: PasswordResetInteractorTestCaseBase {
    private var userService: UserSourceMock!
    
    override func setUp() {
        super.setUp()

        userService = .init()
        userService.user = UserSourceStub.realUserStub()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnSuccessPassReset() {
        interactor.resetPassword(email: "mail@mail.com")
        
        expect(self.interactorObserverSpy.wasSuccessResetPassCalled) == true
    }
}

class PasswordResetInteractorFailTestCase: PasswordResetInteractorTestCaseBase {
    private var userService: UserSourceFailingMock!

    override func setUp() {
        super.setUp()

        userService = .init()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnFailSignIn() {
        userService.error = UserError.networkError

        interactor.resetPassword(email: "")

        expect(self.interactorObserverSpy.wasFailResetPassCalled) == true
    }

    func testShouldCallBackOnFailSignUpWithUserNotFound() {
        userService.error = UserError.userNotFound

        interactor.resetPassword(email: "")

        expect(self.interactorObserverSpy.wasFailResetPassUserNotFoundCalled) == true
    }
}
