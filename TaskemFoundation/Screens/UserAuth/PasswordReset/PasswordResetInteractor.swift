//
//  PasswordResetInteractor.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol PasswordResetInteractorOutput: class {
    func passwordresetInteractorDidSendPasswordReset(_ interactor: PasswordResetInteractor)
    func passwordresetInteractorDidFailSendPasswordReset(_ interactor: PasswordResetInteractor, _ description: String)
    func passwordresetInteractorDidFailSendPasswordResetUserNotFound(_ interactor: PasswordResetInteractor, _ description: String)
}

public protocol PasswordResetInteractor: class {
    var delegate: PasswordResetInteractorOutput? { get set }
    
    func resetPassword(email: String)
}

public class PasswordResetDefaultInteractor: PasswordResetInteractor {
    public var userService: UserService
    public weak var delegate: PasswordResetInteractorOutput?

    public init(userService: UserService) {
        self.userService = userService
    }

    public func resetPassword(email: String) {
        userService.resetPassword(email) { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                let description = error.description
                switch error {
                case .userNotFound:
                    strongSelf.delegate?.passwordresetInteractorDidFailSendPasswordResetUserNotFound(strongSelf, description)
                default:
                    strongSelf.delegate?.passwordresetInteractorDidFailSendPasswordReset(strongSelf, description)
                }
            } else {
                strongSelf.delegate?.passwordresetInteractorDidSendPasswordReset(strongSelf)
            }
        }
    }
}
