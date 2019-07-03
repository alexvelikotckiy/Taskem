//
//  PasswordResetRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class PasswordResetRouterSpy: PasswordResetRouter {
    private(set) var didDismiss = false
    private(set) var didNavigateToSignUp = false
    private(set) var didPresentAlert = false
    
    func dismiss() {
        didDismiss = true
    }
    
    func presentAlert(title: String, message: String?, _ completion: @escaping () -> Void) {
        didPresentAlert = true
    }
    
    func replaceWithSignUp() {
        didNavigateToSignUp = true
    }
}
