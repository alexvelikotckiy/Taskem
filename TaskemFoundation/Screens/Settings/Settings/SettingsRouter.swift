//
//  SettingsRouter.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SettingsRouter {
    func presentLogIn()
    func presentUserProfile()
    func presentNotificationSoundPicker()
    
    func presentDefaultList()
    func presentCompletedTasks()
    func presentReschedule()
}
