//
//  SignInInteractor.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignInInteractorOutput: class {
    func signinInteractorDidSignIn(_ interactor: SignInInteractor, _ user: User)
    func signinInteractorFailSignIn(_ interactor: SignInInteractor, _ description: String)
    func signinInteractorFailSignInEmail(_ interactor: SignInInteractor, _ description: String)
    func signinInteractorFailSignInPass(_ interactor: SignInInteractor, _ description: String)
    func signinInteractorFailSignInUserNotFound(_ interactor: SignInInteractor, _ description: String)
}

public protocol SignInInteractor: class {
    var delegate: SignInInteractorOutput? { get set }
    
    func signIn(_ bean: UserBean)
}

public class SignInDefaultInteractor: SignInInteractor {
    public var userService: UserService
    public weak var delegate: SignInInteractorOutput?

    public init(userService: UserService) {
        self.userService = userService
    }

    public func signIn(_ bean: UserBean) {
        userService.signIn(bean) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.delegate?.signinInteractorDidSignIn(strongSelf, user)
            case .failure(let error):
                let description = error.description
                switch error {
                case .invalidEmail:
                    strongSelf.delegate?.signinInteractorFailSignInEmail(strongSelf, description)
                case .userNotFound:
                    strongSelf.delegate?.signinInteractorFailSignInUserNotFound(strongSelf, description)
                case .wrongPassword:
                    strongSelf.delegate?.signinInteractorFailSignInPass(strongSelf, description)
                default:
                    strongSelf.delegate?.signinInteractorFailSignIn(strongSelf, description)
                }
            }
        }
    }
}
