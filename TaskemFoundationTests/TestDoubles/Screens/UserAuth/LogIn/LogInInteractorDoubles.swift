//
//  LogInInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation
import GoogleSignIn

class LogInInteractorDummy: NSObject, LogInInteractor {
    var delegate: LogInInteractorOutput?
    
    func currentUser() -> User? {
        return nil
    }
    
    func signInAnonymously() {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
}

class LogInInteractorSpy: LogInInteractorDummy {
    var wasSignInAnonymouslyCalled = false
    var wasSignInGoogleCalled = false
    
    override func signInAnonymously() {
        super.signInAnonymously()
        
        wasSignInAnonymouslyCalled = true
    }
    
    override func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        super.sign(signIn, didSignInFor: user, withError: error)
        
        wasSignInGoogleCalled = true
    }
}

class LogInInteractorMock: LogInInteractorSpy {
    var user: User?
    
    override func currentUser() -> User? {
        return user
    }
}

class LogInInteractorObserverSpy: LogInInteractorOutput {
    var signInAnonymouslyUser: User?
    var signInGoogleUser: User?
    var wasFailSignInAnonymouslyCalled = false
    
    var wasWillSignInGoogleCalled = false
    var wasFailSignInGoogleCalled = false
    
    func loginIteractorWillSignInGoogle(_ interactor: LogInInteractor) {
        wasWillSignInGoogleCalled = true
    }
    
    func loginIteractorDidSignInAnonymously(_ interactor: LogInInteractor, _ user: User) {
        signInAnonymouslyUser = user
    }
    
    func loginIteractorFailSignInAnonymously(_ interactor: LogInInteractor, didFailSignInAnonymously error: String) {
        wasFailSignInAnonymouslyCalled = true
    }
    
    func loginIteractorDidSignInGoogle(_ interactor: LogInInteractor, _ user: User) {
        signInGoogleUser = user
    }
    
    func loginIteractorFailSignInGoogle(_ interactor: LogInInteractor, didFailSignIn error: String) {
        wasFailSignInGoogleCalled = true
    }
}
