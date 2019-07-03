//
//  UserPreferencesDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation
import Foundation

class UserPreferencesStub: UserPreferencesProtocol {
    var theme: AppTheme = .light
    var morning: DayTime = dayTimeStub
    var noon: DayTime = dayTimeStub
    var evening: DayTime = dayTimeStub
    var firstWeekday: FirstWeekday = .monday
    var reminderSound: String = ""
    var isFirstLaunch: Bool = false
}

private let dayTimeStub = DayTime(hour: 0, minute: 0)
