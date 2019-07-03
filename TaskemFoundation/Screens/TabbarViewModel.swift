//
//  TabbarViewModel.swift
//  TaskemFoundation
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//
import Foundation

public protocol OnboardingSettings: class {
    var onboardingScreenWasShown: Bool { get set }
    var onboardingDefaultDataWasChoose: Bool { get set }
}

public class SystemOnboardingSettings: OnboardingSettings {
    public init() {

    }

    public var onboardingScreenWasShown: Bool {
        get {
            return userDefaults.bool(forKey: keyOnboardingScreenWasShown)
        }

        set {
            userDefaults.set(newValue, forKey: keyOnboardingScreenWasShown)
            userDefaults.synchronize()
        }
    }

    public var onboardingDefaultDataWasChoose: Bool {
        get {
            return userDefaults.bool(forKey: keyOnboardingDefaultDataWasChoose)
        }

        set {
            userDefaults.set(newValue, forKey: keyOnboardingDefaultDataWasChoose)
            userDefaults.synchronize()
        }
    }

    public var userDefaults: UserDefaults = .standard
    public let keyOnboardingScreenWasShown = "\(Bundle.taskemFoundation.bundleIdentifier!).OnboardingSettings:onboardingScreenWasShown"
    public let keyOnboardingDefaultDataWasChoose = "\(Bundle.taskemFoundation.bundleIdentifier!).OnboardingSettings:onboardingDefaultDataWasChoose"
}

public class TabbarViewModel {
    public var userService: UserService
    
    public init(userService: UserService) {
        self.userService = userService
    }
    
    public func start() {
        userService.addObserver(self)
    }
    
    public func appear() {
        if let user = userService.user {
            onboardingSettings.onboardingScreenWasShown = true
            if let isNew = user.isNew, !isNew {
                if !onboardingSettings.onboardingDefaultDataWasChoose {
                    onShowTemplateSetup?()
                }
            }
        } else {
            if !onboardingSettings.onboardingScreenWasShown {
                onShowOnboarding?()
                onboardingSettings.onboardingScreenWasShown = true
            } else if userService.user == nil {
                onShowUserAuth?()
            }
        }
    }

    public var onShowOnboarding: (() -> Void)?
    public var onShowTemplateSetup: (() -> Void)?
    public var onShowUserAuth: (() -> Void)?
    
    public var onboardingSettings: OnboardingSettings = SystemOnboardingSettings()
}

extension TabbarViewModel: UserObserver {
    public func didUpdateUser(_ user: User?) {
        if !onboardingSettings.onboardingScreenWasShown {
            onShowOnboarding?()
            onboardingSettings.onboardingScreenWasShown = true
        } else {
            if user == nil {
                onShowUserAuth?()
            } else if user?.isNew ?? true {
                onShowTemplateSetup?()
            }
        }
    }
}
