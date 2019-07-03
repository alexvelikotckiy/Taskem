//
//  SignInView.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignInViewDelegate: class {
    func onViewWillAppear()
    func onTouchSignIn(email: String, password: String)
    func onTouchCancel()
    func onTouchResetPassword(email: String)
    func onTouchNavigateSignUp()
}

public protocol SignInView: class {
    var delegate: SignInViewDelegate? { get set }

    func display(_ viewModel: SignInViewModel)
    func displaySpinner(_ isVisible: Bool)
    func postEmailFailure(_ description: String)
    func postPasswordFailure(_ description: String)
    func postFailure(_ description: String)
}
