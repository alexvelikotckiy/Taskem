//
//  SignInRouter.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignInRouter {
    func dismiss()
    func presentAlert(title: String, message: String?)
    func presentPasswordReset(email: String)
    func presentTemplatesSetup()
    func replaceWithSignUp()
}
