//
//  UserProfileInteractor.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserProfileInteractorOutput: class {
    func userprofileInteractorDidSignOut(_ interactor: UserProfileInteractor)
    func userprofileInteractorDidDeleteAccount(_ interactor: UserProfileInteractor)
    func userprofileInteractorDidSendPasswordReset(_ interactor: UserProfileInteractor)
    
    func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailSignOut error: String)
    func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailDeleteAccount error: String)
    func userprofileInteractorDidFail(_ interactor: UserProfileInteractor, didFailResetPass error: String)
}

public protocol UserProfileInteractor: class {
    var delegate: UserProfileInteractorOutput? { get set }
    
    func currentUser() -> User?
    
    func signOut()
    func deleteAccount()
    func resetPassword()
}

public class UserProfileDefaultInteractor: UserProfileInteractor {
    
    public weak var delegate: UserProfileInteractorOutput?
    
    private let userService: UserService

    public init(userService: UserService) {
        self.userService = userService
    }
    
    public func currentUser() -> User? {
        return userService.user
    }
    
    public func signOut() {
        userService.signOut { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.userprofileInteractorDidFail(strongSelf, didFailSignOut: error.description)
            } else {
                strongSelf.delegate?.userprofileInteractorDidSignOut(strongSelf)
            }
        }
    }
    
    public func deleteAccount() {
        userService.deleteUser { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.userprofileInteractorDidFail(strongSelf, didFailDeleteAccount: error.description)
            } else {
                strongSelf.delegate?.userprofileInteractorDidDeleteAccount(strongSelf)
            }
        }
    }
    
    public func resetPassword() {
        guard let user = currentUser(), let email = user.email else { return }
        userService.resetPassword(email) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.delegate?.userprofileInteractorDidFail(strongSelf, didFailResetPass: error.description)
            } else {
                strongSelf.delegate?.userprofileInteractorDidSendPasswordReset(strongSelf)
            }
        }
    }
}
