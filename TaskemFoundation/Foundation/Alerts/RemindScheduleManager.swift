//
//  RemindScheduler.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UserNotifications

public enum RemindSchedulerPermissionResult {
    case allowed
    case prohibited
    case failure(Error)
}

public protocol RemindScheduleManager: class {
    func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void)
    func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void)

    func schedule(_ schedule: RemindSchedule, completion: @escaping (Error?) -> Void)
    func unschedule(for taskId: EntityId, completion: @escaping () -> Void)

    func changeSound(for sound: String)
}

public struct RemindSchedule: Equatable {
    public let id: EntityId
    public let title: String
    public let body: String
    public let date: Date
    public let sound: String
    public let categoryId: String

    public init(
        id: EntityId,
        title: String,
        body: String,
        date: Date,
        sound: String,
        categoryId: String
        ) {
        self.id = id
        self.title = title
        self.body = body
        self.date = date
        self.sound = sound
        self.categoryId = categoryId
    }
}
