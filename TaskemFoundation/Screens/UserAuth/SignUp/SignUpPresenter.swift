//
//  SignUpPresenter.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SignUpPresenter: SignUpViewDelegate {
    
    public weak var view: SignUpView?
    public var router: SignUpRouter
    public var interactor: SignUpInteractor

    public init(
        view: SignUpView,
        router: SignUpRouter,
        interactor: SignUpInteractor
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

    public func onTouchSignUp(name: String, email: String, password: String) {
        if !String.validateName(name) {
            view?.postNameFailure(
                """
                Please input correct name
                (only letters).
                """
            )
            return
        }
        
        if !String.validateMail(email) {
            view?.postEmailFailure(
                """
                Invalid email. Check your email and try again.
                """
            )
            return
        }

        if !String.validatePass(password) {
            view?.postPasswordFailure(
                """
                Your password is too weak. The password must be 6 characters long or more.
                """
            )
            return
        }
        
        view?.displaySpinner(true)
        interactor.signUp(.init(email: email, pass: password, name: name))
    }

    public func onTouchCancel() {
        router.dismiss()
    }
    
    public func onTouchNavigateToSignIn() {
        router.replaceWithSignIn()
    }
}

extension SignUpPresenter: SignUpInteractorOutput {
    public func signupInteractorDidSignUp(_ interactor: SignUpInteractor, _ user: User) {
        view?.displaySpinner(false)
        continueWith(user)
    }

    public func signupInteractorFailSignUp(_ interactor: SignUpInteractor, _ description: String) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Fail to sign up", message: description)
    }

    public func signupInteractorFailSignUpPass(_ interactor: SignUpInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postPasswordFailure(description)
    }

    public func signupInteractorFailSignUpEmail(_ interactor: SignUpInteractor, _ description: String) {
        view?.displaySpinner(false)
        view?.postEmailFailure(description)
    }

    private func continueWith(_ user: User) {
        if let isNew = user.isNew, isNew {
            router.presentTemplatesSetup()
        } else {
            router.dismiss()
        }
    }
}
