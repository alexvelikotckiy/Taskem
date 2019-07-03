//
//  UserSourceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import GoogleSignIn

class UserSourceDummy: UserService {
    var observers: ObserverCollection<UserObserver> = .init()
    var user: User?
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func signInAnonymously(_ completion: @escaping UserAuthResult) {
        
    }
    
    func signIn(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        
    }
    
    func signIn(_ user: GIDGoogleUser, _ completion: @escaping UserAuthResult) {
        
    }
    
    func signUp(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        
    }
    
    func signOut(_ completion: @escaping (UserError?) -> Void) {
        
    }
    
    func resetPassword(_ email: String, _ completion: @escaping (UserError?) -> Void) {
        
    }
    
    func deleteUser(_ completion: @escaping (UserError?) -> Void) {
        
    }
}

class UserSourceStub: UserSourceDummy {
    class func anonymousUserStub() -> User {
        return .init(
            id: "Anonymous User",
            name: "",
            email: "",
            creationDate: Date.now,
            isAnonymous: true,
            isVerifiedEmail: false,
            isNew: false
        )
    }
    
    class func newUserStub() -> User {
        return .init(
            id: "New User",
            name: "User",
            email: "user@mail.com",
            creationDate: Date.now,
            isAnonymous: false,
            isVerifiedEmail: false,
            isNew: true
        )
    }
    
    class func realUserStub() -> User {
        return .init(
            id: "Real User",
            name: "User",
            email: "user@mail.com",
            creationDate: Date.now,
            isAnonymous: false,
            isVerifiedEmail: true,
            isNew: false
        )
    }
}

class UserSourceMock: UserSourceStub {
    override func resetPassword(_ email: String, _ completion: @escaping (UserError?) -> Void) {
        completion(nil)
    }
    
    override func signIn(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        let user = self.user ?? User.init(bean: bean)
        self.user = user
        completion(.success(user))
    }
    
    override func signUp(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        let user = self.user ?? User.init(bean: bean)
        self.user = user
        completion(.success(user))
    }
    
    override func signInAnonymously(_ completion: @escaping UserAuthResult) {
        let user = self.user ?? UserSourceStub.anonymousUserStub()
        self.user = user
        completion(.success(user))
    }
}

class UserSourceFailingMock: UserSourceStub {
    var error: UserError?
    
    override func resetPassword(_ email: String, _ completion: @escaping (UserError?) -> Void) {
        completion(error ?? UserError.unknown)
    }
    
    override func signIn(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        completion(.failure(error ?? UserError.unknown))
    }
    
    override func signUp(_ bean: UserBean, _ completion: @escaping UserAuthResult) {
        completion(.failure(error ?? UserError.unknown))
    }
    
    override func signInAnonymously(_ completion: @escaping UserAuthResult) {
        completion(.failure(error ?? UserError.unknown))
    }
}

private extension User {
    init(bean: UserBean) {
        self.init(
            id: .auto(),
            name: bean.name,
            email: bean.email,
            creationDate: Date.now,
            isAnonymous: false,
            isVerifiedEmail: true,
            isNew: true
        )
    }
}
