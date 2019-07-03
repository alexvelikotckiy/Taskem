//
//  SignInPresenter.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SignInPresenter: SignInViewDelegate {
    
    public weak var view: SignInView?
    public var router: SignInRouter
    public var interactor: SignInInteractor

    public init(
        view: SignInView,
        router: SignInRouter,
        interactor: SignInInteractor
        ) {
        self.router = router
        self.interactor = interactor
        self.interactor.delegate = self

        self.view = view
        if let view = self.view {
            view.delegate = self
        }
    }

    public func onViewWillAppear() {
        
    }

    public func onTouchSignIn(email: String, password: String) {
        if !String.validateMail(email) {
            view?.postEmailFailure(
                """
                Invalid email. Check your email and try again.
                """
            )
            return
        }
        
        view?.displaySpinner(true)
        interactor.signIn(.init(email: email, pass: password))
    }

    public func onTouchResetPassword(email: String) {
        router.presentPasswordReset(email: email)
    }

    public func onTouchCancel() {
        router.dismiss()
    }
    
    public func onTouchNavigateSignUp() {
        router.replaceWithSignUp()
    }
}

extension SignInPresenter: SignInInteractorOutput {
    public func signinInteractorDidSignIn(_ interactor: SignInInteractor, _ user: User) {
        view?.displaySpinner(false)
        continueWith(user)
    }

    public func signinInteractorFailSignIn(_ interactor: SignInInteractor, _ description: String) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Fail to sign in", message: description)
    }

    public func signinInteractorFailSignInEmail(_ interactor: SignInInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postEmailFailure(description)
    }

    public func signinInteractorFailSignInPass(_ interactor: SignInInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postPasswordFailure(description)
    }

    public func signinInteractorFailSignInUserNotFound(_ interactor: SignInInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postFailure(description)
    }

    private func continueWith(_ user: User) {
        if let isNew = user.isNew, isNew {
            router.presentTemplatesSetup()
        } else {
            router.dismiss()
        }
    }
}
