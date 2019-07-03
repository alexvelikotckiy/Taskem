//
//  EventKitService.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import EventKit

public enum EventKitPermissionResult {
    case allowed
    case prohibited
    case failure(Error)
}

public protocol EventKitManager: class {
    func getPermissions() -> EKAuthorizationStatus
    func askForPermissions(completion: @escaping (EventKitPermissionResult) -> Void)
    
    func getCalendar(matchingId id: EntityId) -> EKCalendar?
    func getCalendars() -> [EKCalendar]
    
    func getEvent(matchingId id: EntityId) -> EKEvent?
    func getEvents(matchingInterval interval: DateInterval) -> [EKEvent]

    func reset()
}
