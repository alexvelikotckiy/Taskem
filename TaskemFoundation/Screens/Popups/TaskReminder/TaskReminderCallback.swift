//
//  TaskReminderCallback.swift
//  TaskemFoundation
//
//  Created by Wilson on 13.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public typealias TaskReminderCallback = ((Reminder?) -> Void)

public enum ReminderPresentationStyle {
    case templates
    case manual
}
