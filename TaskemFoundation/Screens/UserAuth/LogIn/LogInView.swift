//
//  LogInView.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol LogInViewDelegate: class {
    func onViewWillAppear()
    func onTouchSignUp()
    func onTouchSignIn()
    func onTouchAnonymousSignIn()
}

public protocol LogInView: class {
    var delegate: LogInViewDelegate? { get set }

    func display(_ viewModel: LogInViewModel)
    func displaySpinner(_ isVisible: Bool)
}
