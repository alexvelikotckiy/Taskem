//
//  DevDashboardInteractor.swift
//  Taskem
//
//  Created by Wilson on 12/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol DevDashboardInteractorOutput: class {

}

public class DevDashboardInteractor {
    let groupSource: GroupSource
    let taskSource: TaskSource
    let devSource: DevDataSource
    weak var delegate: DevDashboardInteractorOutput?

    public init(groupSource: GroupSource, taskSource: TaskSource, devSource: DevDataSource) {
        self.taskSource = taskSource
        self.groupSource = groupSource
        self.devSource = devSource
    }

    func clearDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
        
        SystemOnboardingSettings().onboardingDefaultDataWasChoose = true
        SystemOnboardingSettings().onboardingScreenWasShown = true
    }
    
    func clearNotifications() {
        let center: UNUserNotificationCenter = .current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }
    
    func resetData() {
        let idstasks = taskSource.allTasks.map { $0.id }
        taskSource.remove(byIds: idstasks)
        
        let idsgroups = groupSource.allGroups.map { $0.id }
        groupSource.remove(byIds: idsgroups)
        
        let groups = devSource.devGroups()
        let tasks = devSource.devTasks(groups)
        
        groupSource.add(groups: groups)
        groupSource.setDefalut(byId: groups.first(where: { $0.isDefault })!.id)
        taskSource.add(tasks: tasks)
    }
    
}
