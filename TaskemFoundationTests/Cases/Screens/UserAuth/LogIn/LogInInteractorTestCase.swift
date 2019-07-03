//
//  LogInInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class LogInInteractorTestCase: TaskemTestCaseBase {
    
    fileprivate var interactor: LogInDefaultInteractor!
    fileprivate var interatorObserverSpy: LogInInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
        
        interactor = .init(userService: UserSourceDummy(), googleSignIn: nil)
        interatorObserverSpy = .init()
        interactor.delegate = interatorObserverSpy
    }
    
    func testShouldReturnValidCurrentUser() {
        let userStub = UserSourceStub.anonymousUserStub()
        let userSourceStub = UserSourceStub()
        userSourceStub.user = userStub
        interactor.userService = userSourceStub
        
        let currentUser = interactor.currentUser()
        
        expect(currentUser) == userStub
    }
}

//TODO: Test Goolgle Sign in
class LogInInteractorSuccesTestCase: LogInInteractorTestCase {
    
    func testShouldCallBackOnSuccesSignInAnonymously() {
        let userService = UserSourceMock()
        userService.user = UserSourceStub.anonymousUserStub()
        interactor.userService = userService
        
        interactor.signInAnonymously()
        
        expect(self.interatorObserverSpy.signInAnonymouslyUser!) == userService.user
    }
}

//TODO: Test Goolgle Sign in
class LogInInteractorFailTestCase: LogInInteractorTestCase {
    
    func testShouldCallBackOnFailSignInAnonymously() {
        interactor.userService = UserSourceFailingMock()
        
        interactor.signInAnonymously()
        
        expect(self.interatorObserverSpy.wasFailSignInAnonymouslyCalled) == true
    }
}
