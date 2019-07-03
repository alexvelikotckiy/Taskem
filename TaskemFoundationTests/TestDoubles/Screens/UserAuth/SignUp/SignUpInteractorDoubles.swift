//
//  SignUpInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignUpInteractorDummy: SignUpInteractor {
    var delegate: SignUpInteractorOutput?
    
    func signUp(_ bean: UserBean) {
        
    }
}

class SignUpInteractorSpy: SignUpInteractorDummy {
    var signUpWithBeanCalled: UserBean?
    
    override func signUp(_ bean: UserBean) {
        signUpWithBeanCalled = bean
    }
}

class SignUpInteractorObserverSpy: SignUpInteractorOutput {
    var signUpUser: User?
    var wasFailSignUpCalled = false
    var wasFailSignUpPassCalled = false
    var wasFailSignUpEmailCalled = false
    
    func signupInteractorDidSignUp(_ interactor: SignUpInteractor, _ user: User) {
        signUpUser = user
    }
    
    func signupInteractorFailSignUp(_ interactor: SignUpInteractor, _ description: String) {
        wasFailSignUpCalled = true
    }
    
    func signupInteractorFailSignUpPass(_ interactor: SignUpInteractor, _ description: String) {
        wasFailSignUpPassCalled = true
    }
    
    func signupInteractorFailSignUpEmail(_ interactor: SignUpInteractor, _ description: String) {
        wasFailSignUpEmailCalled = true
    }
}
