//
//  PasswordResetView.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol PasswordResetViewDelegate: class {
    func onViewWillAppear()
    func onTouchReset(email: String)
    func onTouchNavigateToSignUp()
}

public protocol PasswordResetView: class {
    var delegate: PasswordResetViewDelegate? { get set }

    func display(_ viewModel: PasswordResetViewModel)
    func displaySpinner(_ isVisible: Bool)
    func postEmailFailure(_ description: String)
    func postFailure(_ description: String)
}
