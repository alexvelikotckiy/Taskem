//
//  LogInRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class LogInRouterSpy: LogInRouter {
    private(set) var didDismiss = false
    private(set) var didPresentEmailSignUp = false
    private(set) var didPresentSignIn = false
    private(set) var didPresentAlert = false
    private(set) var didPresentTemplatesSetup = false

    func dismiss() {
        didDismiss = true
    }
    
    func presentEmailSignUp() {
        didPresentEmailSignUp = true
    }
    
    func presentSignIn() {
        didPresentSignIn = true
    }
    
    func presentAlert(title: String, message: String?) {
        didPresentAlert = true
    }
    
    func presentTemplatesSetup() {
        didPresentTemplatesSetup = true
    }
}
