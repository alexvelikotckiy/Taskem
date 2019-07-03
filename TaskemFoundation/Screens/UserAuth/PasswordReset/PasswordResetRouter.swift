//
//  PasswordResetRouter.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol PasswordResetRouter {
    func dismiss()
    func presentAlert(title: String, message: String?, _ completion: @escaping () -> Void)
    func replaceWithSignUp()
}
