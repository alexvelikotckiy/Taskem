//
//  ReminderSchedulerDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import UserNotifications

class RemindScheduleManagerDummy: RemindScheduleManager {
    func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        
    }
    
    func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        
    }
    
    func schedule(_ schedule: RemindSchedule, completion: @escaping (Error?) -> Void) {
        
    }
    
    func unschedule(for taskId: EntityId, completion: @escaping () -> Void) {
        
    }
    
    func changeSound(for sound: String) {
        
    }
}

class AuthorizedRemindSchedulerManagerStub: RemindScheduleManagerDummy {
    override func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        completion(.authorized)
    }
    
    override func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        completion(.allowed)
    }
}

class NotDeterminedRemindSchedulerManagerMock: RemindScheduleManagerDummy {
    var permissionsResult: RemindSchedulerPermissionResult!
    
    override func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        completion(.notDetermined)
    }
    
    override func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        completion(permissionsResult)
    }
}

class UnauthorizedRemindSchedulerManagerStub: RemindScheduleManagerDummy {
    override func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        completion(.denied)
    }
    
    override func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        completion(.prohibited)
    }
}

class RemindScheduleManagerSpy: RemindScheduleManagerDummy {
    
    var scheduleCalls: [RemindSchedule] = []
    var unscheduleCalls: [UnscheduleCall] = []
    var getPermissionsCalls: [(UNAuthorizationStatus) -> Void] = []
    var askForPermissionsCalls: [(RemindSchedulerPermissionResult) -> Void] = []
    
    var changeSoundCalls: [String] = []
    var lastChangedSound: String? {
        return changeSoundCalls.last
    }
    
    struct UnscheduleCall {
        let entityId: EntityId
        let completion: () -> Void
    }
    
    override func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        getPermissionsCalls.append(completion)
    }
    
    override func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        askForPermissionsCalls.append(completion)
    }
    
    override func schedule(_ schedule: RemindSchedule, completion: @escaping (Error?) -> Void) {
        scheduleCalls.append(schedule)
        completion(nil)
    }
    
    override func unschedule(for taskId: EntityId, completion: @escaping () -> Void) {
        unscheduleCalls.append(UnscheduleCall(entityId: taskId, completion: completion))
        completion()
    }
    
    override func changeSound(for sound: String) {
        changeSoundCalls.append(sound)
    }
}
