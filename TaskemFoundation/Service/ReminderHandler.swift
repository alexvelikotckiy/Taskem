//
//  ReminderHandler.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol NotificationHandler: class {
    var dataHandler: NotificationHandlerDataUpdater { get }
    func start()
}

public protocol NotificationHandlerDataUpdater: class {
    func setTaskAsComplete(by id: EntityId, _ completion: @escaping (() -> Void))
    func setTaskRemindInHour(by id: EntityId, _ completion: @escaping (() -> Void))
}
