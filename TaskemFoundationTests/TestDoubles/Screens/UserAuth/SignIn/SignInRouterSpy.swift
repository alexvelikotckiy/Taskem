//
//  SignInRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignInRouterSpy: SignInRouter {
    private(set) var didDismiss = false
    private(set) var didNavigateToSignUp = false
    private(set) var didPresentAlert = false
    private(set) var didPresentTemplatesSetup = false
    private(set) var didPresentPasswordReset = false
    
    func dismiss() {
        didDismiss = true
    }
    
    func presentAlert(title: String, message: String?) {
        didPresentAlert = true
    }
    
    func presentPasswordReset(email: String) {
        didPresentPasswordReset = true
    }
    
    func presentTemplatesSetup() {
        didPresentTemplatesSetup = true
    }
    
    func replaceWithSignUp() {
        didNavigateToSignUp = true
    }
}
