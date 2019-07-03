//
//  IOSReminderScheduler.swift
//  Taskem
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation
import UserNotifications

public class IOSReminderScheduler: RemindScheduleManager {

    private var center: UNUserNotificationCenter = .current()
    private let identityProvider = SystemNotificationIdentityProvider.standard
    private let appBadge: ApplicationBadge

    public init(appBadge: ApplicationBadge) {
        self.appBadge = appBadge
    }

    public func getPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    public func askForPermissions(completion: @escaping (RemindSchedulerPermissionResult) -> Void) {
        center.requestAuthorization(options: [.badge, .sound, .alert]) { flag, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completion(flag ? .allowed : .prohibited)
                }
            }
        }
    }

    public func schedule(_ schedule: RemindSchedule, completion handler: @escaping (Error?) -> Void) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: .current, from: schedule.date)
        let components = DateComponents(
            calendar: calendar,
            timeZone: .current,
            year: dateComponents.year,
            month: dateComponents.month,
            day: dateComponents.day,
            hour: dateComponents.hour,
            minute: dateComponents.minute
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = schedule.title
        content.body = schedule.body
        content.sound = notificationSound(forName: schedule.sound)
        content.categoryIdentifier = schedule.categoryId

        let request = UNNotificationRequest(
            identifier: schedule.id,
            content: content,
            trigger: trigger
        )

        center.add(request, withCompletionHandler: handler)
    }
    
    public func unschedule(for entityId: EntityId, completion: @escaping () -> Void) {
        center.getPendingNotificationRequests { requests in
            let ids = requests.map { $0.identifier }
            let idsMatchingTracker = ids.filter(self.specificReminderPredicate(entityId: entityId))
            self.center.removePendingNotificationRequests(withIdentifiers: idsMatchingTracker)
            completion()
        }
    }

    public func changeSound(for sound: String) {
        center.getPendingNotificationRequests { requests in
            let requests = requests.filter { self.reminderRequestPredicate($0.identifier) }
            self.center.removePendingNotificationRequests(withIdentifiers: requests.map({ $0.identifier }))
            for request in requests {
                self.center.add(self.changeSound(for: sound, in: request), withCompletionHandler: nil)
            }
        }
    }

    private func changeSound(for sound: String, in request: UNNotificationRequest) -> UNNotificationRequest {
        let id = request.identifier
        let content = UNMutableNotificationContent()
        content.title = request.content.title
        content.body = request.content.body
        content.sound = notificationSound(forName: sound)
        content.categoryIdentifier = request.content.categoryIdentifier
        return UNNotificationRequest(identifier: id, content: content, trigger: request.trigger!)
    }

    private func notificationSound(forName name: String) -> UNNotificationSound {
        if name == "default" {
            return UNNotificationSound.default
        } else {
            return UNNotificationSound.init(named: UNNotificationSoundName(rawValue: name + ".m4a"))
        }
    }

    private func reminderRequestPredicate(_ id: String) -> Bool {
        return id.starts(with: identityProvider.reminderBase)
    }

    private func specificReminderPredicate(entityId: EntityId) -> (String) -> Bool {
        return { self.identityProvider.entityId(from: $0) == entityId }
    }

}
