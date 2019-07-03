//
//  SignInInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class SignInInteractorTestCaseBase: TaskemTestCaseBase {

    fileprivate var interactor: SignInDefaultInteractor!
    fileprivate var interactorObserverSpy: SignInInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
        
        interactor = .init(userService: UserSourceDummy())
        interactorObserverSpy = .init()
        interactor.delegate = interactorObserverSpy
    }
}

class SignInInteractorSuccessTestCase: SignInInteractorTestCaseBase {
    
    private var userService: UserSourceMock!
    
    override func setUp() {
        super.setUp()
        
        userService = .init()
        userService.user = UserSourceStub.realUserStub()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnSuccessSignIn() {
        interactor.signIn(.init(email: "mail@mail.com", pass: "password"))
        
        expect(self.interactorObserverSpy.signInUser).toNot(beNil())
    }
}

class SignInInteractorFailTestCase: SignInInteractorTestCaseBase {
    
    private var userService: UserSourceFailingMock!
    
    override func setUp() {
        super.setUp()

        userService = .init()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnFailSignIn() {
        userService.error = UserError.networkError
        
        interactor.signIn(.init(email: "", pass: ""))
        
        expectNilUser()
        expect(self.interactorObserverSpy.wasFailSignInCalled) == true
    }
    
    func testShouldCallBackOnFailSignUpWithWrongEmail() {
        userService.error = UserError.invalidEmail
        
        interactor.signIn(.init(email: "", pass: ""))
        
        expectNilUser()
        expect(self.interactorObserverSpy.wasFailSignInEmailCalled) == true
    }

    func testShouldCallBackOnFailSignUpWithWrongPass() {
        userService.error = UserError.wrongPassword
        
        interactor.signIn(.init(email: "", pass: ""))
        
        expectNilUser()
        expect(self.interactorObserverSpy.wasFailSignInPassCalled) == true
    }
    
    func testShouldCallBackOnFailSignUpWithUserNotFound() {
        userService.error = UserError.userNotFound
        
        interactor.signIn(.init(email: "", pass: ""))
        
        expectNilUser()
        expect(self.interactorObserverSpy.wasFailSignInUserNotFound) == true
    }
    
    private func expectNilUser(line: UInt = #line) {
        expect(self.interactorObserverSpy.signInUser, line: line).to(beNil())
    }
    
}
