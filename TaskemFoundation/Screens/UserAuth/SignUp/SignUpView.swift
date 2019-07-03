//
//  SignUpView.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SignUpViewDelegate: class {
    func onViewWillAppear()
    func onTouchSignUp(name: String, email: String, password: String)
    func onTouchCancel()
    func onTouchNavigateToSignIn()
}

public protocol SignUpView: class {
    var delegate: SignUpViewDelegate? { get set }

    func display(_ viewModel: SignUpViewModel)
    func displaySpinner(_ isVisible: Bool)
    func postNameFailure(_ description: String)
    func postEmailFailure(_ description: String)
    func postPasswordFailure(_ description: String)
}
