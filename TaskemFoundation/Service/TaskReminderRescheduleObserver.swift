//
//  TaskReminderRescheduleObserver.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskReminderRescheduleObserver: TaskSourceObserver {
    var scheduler: RemindScheduleManager { get set }
}
