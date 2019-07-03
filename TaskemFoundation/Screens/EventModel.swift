//
//  EventModel.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct EventModel: Equatable {
    public var event: EventKitTask
    public var occurrenceDate: Date
    
    public init(event: EventKitTask,
                displayDate: Date) {
        self.event = event
        self.occurrenceDate = displayDate
    }
    
    public var id: EntityId {
        return event.id
    }
    
    public var idOccurrence: EntityId {
        return event.id + ":" + occurrenceDate.dateToString(format: "MM.dd.yyyy")
    }
    
    public var calendarName: String {
        return event.calendar.title
    }
    
    public var idCalednar: String {
        return event.calendar.id
    }
    
    public var name: String {
        return event.name
    }
    
    public var startDate: Date {
        return event.interval.start
    }

    public var endDate: Date {
        return event.interval.end
    }

    public var color: Color {
        return event.color
    }
    
    public var isSingleDayEvent: Bool {
        return Calendar.current.taskem_isSameDay(date: startDate, in: endDate)
    }
    
    public var displayDate: String {
        switch true {
        case Calendar.current.taskem_isSameDay(date: occurrenceDate, in: startDate):
            return startTimeFormatted ?? ""
        case Calendar.current.taskem_isSameDay(date: occurrenceDate, in: endDate):
            return endTimeFormatted ?? ""
        default:
            return ""
        }
    }
    
    public var isAllDay: Bool {
        if event.isAllDay { return true }
        
        switch true {
        case Calendar.current.taskem_isSameDay(date: occurrenceDate, in: startDate):
            return false
        case Calendar.current.taskem_isSameDay(date: occurrenceDate, in: endDate):
            return false
        default:
            return true
        }
    }
}

public extension EventModel {
    var startTimeFormatted: String? {
        if event.isAllDay { return nil }
        let dateFormatted = DateFormatter()
        dateFormatted.dateStyle = .none
        dateFormatted.timeStyle = .short
        return dateFormatted.string(from: event.interval.start)
    }
    
    var endTimeFormatted: String? {
        if event.isAllDay { return nil }
        let dateFormatted = DateFormatter()
        dateFormatted.dateStyle = .none
        dateFormatted.timeStyle = .short
        return dateFormatted.string(from: event.interval.end)
    }
}

extension EventKitTask {
    public func convertToModel(at filter: DateInterval) -> [EventModel] {
        let dates = Calendar.current.taskem_generateDays(interval).filter { filter.contains($0) }.map { TimelessDate($0) }
        return dates.map { EventModel(event: self, displayDate: $0.value) }
    }
    
    public func convertToModel() -> [EventModel] {
        let dates = Calendar.current.taskem_generateDays(interval).map { TimelessDate($0) }
        return dates.map { EventModel(event: self, displayDate: $0.value) }
    }
}
