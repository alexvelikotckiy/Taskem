//
//  UserService.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import GoogleSignIn

public enum UserError: CustomStringConvertible {
    case unknown
    case invalidEmail
    case userNotFound
    case wrongPassword
    case weakPassword
    case emailAlreadyInUse
    case networkError
    
    
    public var description: String {
        switch self {
        case .unknown:
            return "Couldn't continue. An error has occurred."
        case .invalidEmail:
            return "Invalid email. Check your email and try again."
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .emailAlreadyInUse:
            return "The email is already in use with another account."
        case .networkError:
            return "Network error. Please try again."
        }
    }
}

public typealias UserAuthResult = (Result<User, UserError>) -> Void

public protocol UserService: class {
    var observers: ObserverCollection<UserObserver> { get set }
    var user: User? { get }

    func start()
    func stop()

    func signInAnonymously(_ completion: @escaping UserAuthResult)
    func signIn(_ bean: UserBean, _ completion: @escaping UserAuthResult)
    func signIn(_ user: GIDGoogleUser, _ completion: @escaping UserAuthResult)
    func signUp(_ bean: UserBean, _ completion: @escaping UserAuthResult)
    func signOut(_ completion: @escaping (UserError?) -> Void)
    func resetPassword(_ email: String, _ completion: @escaping (UserError?) -> Void)
    func deleteUser(_ completion: @escaping (UserError?) -> Void)
}

public protocol UserObserver: class {
    func didUpdateUser(_ user: User?)
}

public extension UserService {
    func addObserver(_ observer: UserObserver) {
        observers.append(observer)
    }

    func removeObserver(_ observer: UserObserver) {
        observers.remove(observer)
    }

    func notifyDidUpdateUser(user: User?) {
        for observer in observers {
            observer?.didUpdateUser(user)
        }
    }
}
