//
//  SignInInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignInInteractorDummy: SignInInteractor {
    var delegate: SignInInteractorOutput?
    
    func signIn(_ bean: UserBean) {
        
    }
}

class SignInInteractorSpy: SignInInteractorDummy {
    var signInWithBeanCalled: UserBean?

    override func signIn(_ bean: UserBean) {
        signInWithBeanCalled = bean
    }
}

class SignInInteractorObserverSpy: SignInInteractorOutput {
    var signInUser: User?
    var wasFailSignInCalled = false
    var wasFailSignInPassCalled = false
    var wasFailSignInEmailCalled = false
    var wasFailSignInUserNotFound = false
    
    func signinInteractorDidSignIn(_ interactor: SignInInteractor, _ user: User) {
        signInUser = user
    }
    
    func signinInteractorFailSignIn(_ interactor: SignInInteractor, _ description: String) {
        wasFailSignInCalled = true
    }
    
    func signinInteractorFailSignInEmail(_ interactor: SignInInteractor, _ description: String) {
        wasFailSignInEmailCalled = true
    }
    
    func signinInteractorFailSignInPass(_ interactor: SignInInteractor, _ description: String) {
        wasFailSignInPassCalled = true
    }
    
    func signinInteractorFailSignInUserNotFound(_ interactor: SignInInteractor, _ description: String) {
        wasFailSignInUserNotFound = true
    }
}
