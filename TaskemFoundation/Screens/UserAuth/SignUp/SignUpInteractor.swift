//
//  SignUpInteractor.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignUpInteractorOutput: class {
    func signupInteractorDidSignUp(_ interactor: SignUpInteractor, _ user: User)
    func signupInteractorFailSignUp(_ interactor: SignUpInteractor, _ description: String)
    func signupInteractorFailSignUpPass(_ interactor: SignUpInteractor, _ description: String)
    func signupInteractorFailSignUpEmail(_ interactor: SignUpInteractor, _ description: String)
}

public protocol SignUpInteractor: class {
    var delegate: SignUpInteractorOutput? { get set }

    func signUp(_ bean: UserBean)
}

public class SignUpDefaultInteractor: SignUpInteractor {
    public var userService: UserService
    public weak var delegate: SignUpInteractorOutput?

    public init(userService: UserService) {
        self.userService = userService
    }

    public func signUp(_ bean: UserBean) {
        userService.signUp(bean) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.delegate?.signupInteractorDidSignUp(strongSelf, user)
            case .failure(let error):
                let description = error.description
                switch error {
                case .invalidEmail, .emailAlreadyInUse:
                    strongSelf.delegate?.signupInteractorFailSignUpEmail(strongSelf, description)
                case .weakPassword:
                    strongSelf.delegate?.signupInteractorFailSignUpPass(strongSelf, description)
                default:
                    strongSelf.delegate?.signupInteractorFailSignUp(strongSelf, description)
                }
            }
        }
    }

}
