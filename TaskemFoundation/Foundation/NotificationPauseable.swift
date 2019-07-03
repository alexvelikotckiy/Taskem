//
//  NotificationPauseable.swift
//  TaskemFoundation
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

public protocol NotificationPauseable: class {
    func pause(onCompletion notification: Notification.Name?, _ block: () -> Void)
}
