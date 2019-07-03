//
//  LogInInteractor.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import GoogleSignIn

public protocol LogInInteractorOutput: class {
    func loginIteractorWillSignInGoogle(_ interactor: LogInInteractor)
    func loginIteractorDidSignInAnonymously(_ interactor: LogInInteractor, _ user: User)
    func loginIteractorFailSignInAnonymously(_ interactor: LogInInteractor, didFailSignInAnonymously error: String)

    func loginIteractorDidSignInGoogle(_ interactor: LogInInteractor, _ user: User)
    func loginIteractorFailSignInGoogle(_ interactor: LogInInteractor, didFailSignIn error: String)
}

public protocol LogInInteractor: class, GIDSignInDelegate {
    var delegate: LogInInteractorOutput? { get set }
    
    func currentUser() -> User?
    func signInAnonymously()
}

public class LogInDefaultInteractor: NSObject, LogInInteractor {
    public var userService: UserService
    public weak var delegate: LogInInteractorOutput?

    public init(userService: UserService, googleSignIn: GIDSignIn?) {
        self.userService = userService
        super.init()
        googleSignIn?.delegate = self
    }

    public func signInAnonymously() {
        userService.signInAnonymously { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.delegate?.loginIteractorDidSignInAnonymously(strongSelf, user)
            case .failure(let error):
                strongSelf.delegate?.loginIteractorFailSignInAnonymously(strongSelf, didFailSignInAnonymously: error.description)
            }
        }
    }

    public func currentUser() -> User? {
        return userService.user
    }
}

extension LogInDefaultInteractor: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            delegate?.loginIteractorFailSignInGoogle(self, didFailSignIn: "Fail to google sign in.")
            return
        }
        
        delegate?.loginIteractorWillSignInGoogle(self)
        userService.signIn(user) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.delegate?.loginIteractorDidSignInGoogle(strongSelf, user)
            case .failure(let error):
                strongSelf.delegate?.loginIteractorFailSignInGoogle(strongSelf, didFailSignIn: error.description)
            }
        }
    }
}
