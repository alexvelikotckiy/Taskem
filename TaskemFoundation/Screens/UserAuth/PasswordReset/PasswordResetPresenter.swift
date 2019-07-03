//
//  PasswordResetPresenter.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class PasswordResetPresenter: PasswordResetViewDelegate {
    
    public weak var view: PasswordResetView?
    public var router: PasswordResetRouter
    public var interactor: PasswordResetInteractor

    private var initialEmail: String
    
    public init(
        view: PasswordResetView,
        router: PasswordResetRouter,
        interactor: PasswordResetInteractor,
        email: String
        ) {
        self.router = router
        self.interactor = interactor
        
        self.initialEmail = email
        
        self.interactor.delegate = self

        self.view = view
        if let view = self.view {
            view.delegate = self
        }
    }

    private func displayViewModel() {
        view?.display(.init(email: initialEmail))
    }

    public func onViewWillAppear() {
        displayViewModel()
    }

    public func onTouchReset(email: String) {
        if !String.validateMail(email) {
            view?.postEmailFailure(
                """
                Invalid email. Check your email and try again.
                """
            )
            return
        }
        
        view?.displaySpinner(true)
        interactor.resetPassword(email: email)
    }
    
    public func onTouchNavigateToSignUp() {
        router.replaceWithSignUp()
    }
}

extension PasswordResetPresenter: PasswordResetInteractorOutput {
    public func passwordresetInteractorDidFailSendPasswordReset(_ interactor: PasswordResetInteractor, _ description: String) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Fail", message: description) {}
    }

    public func passwordresetInteractorDidFailSendPasswordResetUserNotFound(_ interactor: PasswordResetInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postEmailFailure(description)
    }

    public func passwordresetInteractorDidSendPasswordReset(_ interactor: PasswordResetInteractor) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Check your email", message: "We have send on your email recover instructions.") {
            self.router.dismiss()
        }
    }
}
