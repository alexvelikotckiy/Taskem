//
//  LogInPresenter.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class LogInPresenter: LogInViewDelegate {
    
    private weak var view: LogInView?
    private var router: LogInRouter
    private var interactor: LogInInteractor
    
    public var onboardingSettings: OnboardingSettings = SystemOnboardingSettings()

    public init(view: LogInView,
                router: LogInRouter,
                interactor: LogInInteractor) {
        self.router = router
        self.interactor = interactor
        self.interactor.delegate = self

        self.view = view
        if let view = self.view {
            view.delegate = self
        }
    }

    public func onViewWillAppear() {
        var anonymousSignInTitle = ""
        if let user = interactor.currentUser() {
            if user.isAnonymous {
                anonymousSignInTitle = "Keep using taskem..."
            }
            if let isNew = user.isNew, !isNew {
                onboardingSettings.onboardingDefaultDataWasChoose = true
            }
            onboardingSettings.onboardingScreenWasShown = true
        } else {
            anonymousSignInTitle = "Sign up later..."
        }
        view?.display(.init(anonymousSignInTitle: anonymousSignInTitle))
    }

    public func onTouchSignUp() {
        router.presentEmailSignUp()
    }

    public func onTouchSignIn() {
        router.presentSignIn()
    }

    public func onTouchAnonymousSignIn() {
        if let user = interactor.currentUser(), user.isAnonymous {
            router.dismiss()
        } else {
            view?.displaySpinner(true)
            interactor.signInAnonymously()
        }
    }
}

extension LogInPresenter: LogInInteractorOutput {
    public func loginIteractorWillSignInGoogle(_ interactor: LogInInteractor) {
        view?.displaySpinner(true)
    }
    
    public func loginIteractorDidSignInGoogle(_ interactor: LogInInteractor, _ user: User) {
        view?.displaySpinner(false)
        continueWith(user)
    }
    
    public func loginIteractorFailSignInGoogle(_ interactor: LogInInteractor, didFailSignIn error: String) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Fail to sign in", message: error)
    }
    
    public func loginIteractorDidSignInAnonymously(_ interactor: LogInInteractor, _ user: User) {
        view?.displaySpinner(false)
        continueWith(user)
    }

    public func loginIteractorFailSignInAnonymously(_ interactor: LogInInteractor, didFailSignInAnonymously error: String) {
        view?.displaySpinner(false)
        router.presentAlert(title: "Fail to sign in", message: error)
    }

    private func continueWith(_ user: User) {
        onboardingSettings.onboardingScreenWasShown = true
        if let isNew = user.isNew, isNew {
            onboardingSettings.onboardingDefaultDataWasChoose = false
            router.presentTemplatesSetup()
        } else {
            onboardingSettings.onboardingDefaultDataWasChoose = true
            router.dismiss()
        }
    }
}
