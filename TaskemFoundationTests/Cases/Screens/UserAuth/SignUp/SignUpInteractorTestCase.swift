//
//  SignUpInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class SignUpInteractorTestCaseBase: TaskemTestCaseBase {

    fileprivate var interactor: SignUpDefaultInteractor!
    fileprivate var interatorObserverSpy: SignUpInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
     
        interactor = SignUpDefaultInteractor(userService: UserSourceDummy())
        interatorObserverSpy = .init()
        interactor.delegate = interatorObserverSpy
    }
}

class SignUpInteractorSuccesTestCase: SignUpInteractorTestCaseBase {
    
    private var userService: UserSourceMock!
    
    override func setUp() {
        super.setUp()
        
        userService = .init()
        userService.user = UserSourceStub.realUserStub()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnSuccesSignUp() {
        interactor.signUp(.init(email: "mail@mail.com", pass: "password", name: "User name"))
        
        expect(self.interatorObserverSpy.signUpUser).toNot(beNil())
    }
}

class SignUpInteractorFailTestCase: SignUpInteractorTestCaseBase {
    
    private var userService: UserSourceFailingMock!
    
    override func setUp() {
        super.setUp()
        
        userService = .init()
        interactor.userService = userService
    }
    
    func testShouldCallBackOnFailSignUp() {
        userService.error = UserError.networkError
        
        interactor.signUp(.init(email: "", pass: ""))
        
        expect(self.interatorObserverSpy.signUpUser).to(beNil())
        expect(self.interatorObserverSpy.wasFailSignUpCalled) == true
    }
    
    func testShouldCallBackOnFailSignUpWithWrongEmail() {
        userService.error = UserError.invalidEmail
        
        interactor.signUp(.init(email: "", pass: ""))
        
        expect(self.interatorObserverSpy.signUpUser).to(beNil())
        expect(self.interatorObserverSpy.wasFailSignUpEmailCalled) == true
    }
    
    func testShouldCallBackOnFailSignUpWithWrongPass() {
        userService.error = UserError.weakPassword
        
        interactor.signUp(.init(email: "", pass: ""))
        
        expect(self.interatorObserverSpy.signUpUser).to(beNil())
        expect(self.interatorObserverSpy.wasFailSignUpPassCalled) == true
    }
}
