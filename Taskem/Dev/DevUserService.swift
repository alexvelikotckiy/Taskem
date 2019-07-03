//
//  DevUserService.swift
//  Taskem
//
//  Created by Wilson on 6/26/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import GoogleSignIn

class DevUserService: UserService {
    var observers: ObserverCollection<UserObserver>
    
    var user: TaskemFoundation.User?
    var users: [TaskemFoundation.User]
    
    public init() {
        observers = []
        users = []
        user = self.defaultUser
        users.append(user!)
    }
    
    private var defaultUser: TaskemFoundation.User {
        return .init(
            id: .auto(),
            name: "123",
            email: "123@123.com",
            creationDate: Date(),
            isAnonymous: false,
            isVerifiedEmail: true,
            isNew: false
        )
    }
    
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
