//
//  LogInRouter.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol LogInRouter {
    func dismiss()
    func presentEmailSignUp()
    func presentSignIn()
    func presentAlert(title: String, message: String?)
    func presentTemplatesSetup()
}
