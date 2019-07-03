//
//  SettingsRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SettingsRouterSpy: SettingsRouter {
    var didPresentLogIn = false
    var didPresentUserProfile = false
    var didPresentNotificationSoundPicker = false
    var didPresentDefaultList = false
    var didPresentCompletedTasks = false
    var didPresentReschedule = false
    
    func presentLogIn() {
        didPresentLogIn = true
    }
    
    func presentUserProfile() {
        didPresentUserProfile = true
    }
    
    func presentNotificationSoundPicker() {
        didPresentNotificationSoundPicker = true
    }
    
    func presentDefaultList() {
        didPresentDefaultList = true
    }
    
    func presentCompletedTasks() {
        didPresentCompletedTasks = true
    }
    
    func presentReschedule() {
        didPresentReschedule = true
    }
}
