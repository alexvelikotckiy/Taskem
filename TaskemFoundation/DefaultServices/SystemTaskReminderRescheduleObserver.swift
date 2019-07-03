//
//  SystemTaskReminderRescheduleObserver.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SystemTaskReminderRescheduleObserver: TaskReminderRescheduleObserver {

    public var scheduler: RemindScheduleManager
    public var identityProvider: NotificationIdentityProvider

    public init(scheduler: RemindScheduleManager,
                identityProvider: NotificationIdentityProvider = SystemNotificationIdentityProvider.standard) {
        self.scheduler = scheduler
        self.identityProvider = identityProvider
    }

    public func sourceDidChangeState(_ source: TaskSource) {
        if source.state == .loaded {
            processAddOrUpdate(tasks: source.allTasks)
        }
    }

    public func source(_ source: TaskSource, didAdd tasks: [Task]) {
        processAddOrUpdate(tasks: tasks)
    }

    public func source(_ source: TaskSource, didUpdate tasks: [Task]) {
        processAddOrUpdate(tasks: tasks)
    }

    public func source(_ source: TaskSource, didRemove ids: [EntityId]) {
        ids.forEach { scheduler.unschedule(for: $0) {} }
    }

    private func processAddOrUpdate(tasks: [Task]) {
        for task in tasks {
            scheduler.unschedule(for: task.id) { [weak self, task] in
                guard let strongSelf = self else { return }
                strongSelf.schedule(task: task)
            }
        }
    }
    
    private func schedule(task: Task) {
        guard !task.isComplete else { return }

        guard let reminderDate = task.reminder.remindDate,
            task.reminder.isOn else { return }

        let category = NotificationCategory.task

        let notificationId = identityProvider.produceNotificationId(
            category: category,
            entityId: task.id,
            reminderId: task.reminder.id,
            date: reminderDate
        )

        let categoryId = identityProvider.produceCategoryNotificationId(category.rawValue)

        let schedule = RemindSchedule(
            id: notificationId,
            title: task.name,
            body: task.notes,
            date: reminderDate,
            sound: UserPreferences.current.reminderSound,
            categoryId: categoryId
        )

        scheduler.schedule(schedule) { _ in }
    }
    
}
