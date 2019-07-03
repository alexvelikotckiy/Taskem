//
//  IOSEventKitService.swift
//  Taskem
//
//  Created by Wilson on 4/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import EventKit

class IOSEventKitService: EventKitManager {
    private var eventStore = EKEventStore()

    public init() {

    }
    
    func getPermissions() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }

    func askForPermissions(completion: @escaping (EventKitPermissionResult) -> Void) {
        eventStore.requestAccess(to: .event) { allowed, error in
            // https://stackoverflow.com/questions/48302813/eventkit-error-getting-meetings-ios-11-2-2-on-initial-load
            self.eventStore = EKEventStore()
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completion(allowed ? .allowed : .prohibited)
                }
            }
        }
    }

    func getCalendar(matchingId id: EntityId) -> EKCalendar? {
        return eventStore.calendar(withIdentifier: id)
    }
    
    func getCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }
    
    func getEvent(matchingId id: EntityId) -> EKEvent? {
        return eventStore.event(withIdentifier: id)
    }
    
    func getEvents(matchingInterval interval: DateInterval) -> [EKEvent] {
        let predicate = eventStore.predicateForEvents(withStart: interval.start.startOfDay, end: interval.end.endOfDay, calendars: nil)
        return eventStore.events(matching: predicate)
    }

    func reset() {
        eventStore.reset()
    }
}
