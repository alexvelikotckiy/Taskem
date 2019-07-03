//
//  EventKitTask.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import EventKit

public struct EventKitTask: Identifiable, Equatable {
    public var id: EntityId
    public let calendar: EventKitCalendar
    public var name: String
    public var isAllDay: Bool
    public var interval: DateInterval
    public var color: Color

    public init(
        id: EntityId,
        calendar: EventKitCalendar,
        name: String,
        isAllDay: Bool,
        interval: DateInterval,
        color: Color
        ) {
        self.id = id
        self.calendar = calendar
        self.name = name
        self.interval = interval
        self.isAllDay = isAllDay
        self.color = color
    }

    public init(event: EKEvent) {
        self.init(
            id: event.eventIdentifier,
            calendar: .init(calendar: event.calendar),
            name: event.title,
            isAllDay: event.isAllDay,
            interval: .init(start: event.startDate, end: event.endDate),
            color: Color(hex: UIColor(cgColor: event.calendar.cgColor).toHexString())
        )
    }
    
    public var allowsContentModifications: Bool {
        return calendar.allowsContentModifications
    }
}
