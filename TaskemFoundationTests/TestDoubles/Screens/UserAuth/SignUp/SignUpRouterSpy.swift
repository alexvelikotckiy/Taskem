//
//  SignUpRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignUpRouterSpy: SignUpRouter {
    private(set) var didDismiss = false
    private(set) var didNavigateToSignIn = false
    private(set) var didPresentAlert = false
    private(set) var didPresentTemplatesSetup = false
    
    func dismiss() {
        didDismiss = true
    }
    
    func presentAlert(title: String, message: String?) {
        didPresentAlert = true
    }
    
    func presentTemplatesSetup() {
        didPresentTemplatesSetup = true
    }
    
    func replaceWithSignIn() {
        didNavigateToSignIn = true
    }
}
