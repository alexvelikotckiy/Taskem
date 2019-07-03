//
//  SignUpRouter.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignUpRouter {
    func dismiss()
    func presentAlert(title: String, message: String?)
    func presentTemplatesSetup()
    func replaceWithSignIn()
}
