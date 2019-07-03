//
//  DatePreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct DatePreferences: Codable, Equatable {
    // Date of the first estimate(it needs to calculate next occurrenceDate)
    private(set) public var firstOccurrenceDate: Date?
    
    // All repeat dates following after firstOccurrenceDate
    private(set) public var occurrenceDate: Date?
    
    public var isAllDay: Bool

    public init() {
        self.firstOccurrenceDate = nil
        self.occurrenceDate = nil
        self.isAllDay = false
    }

    public init(assumedDate: Date?,
                isAllDay: Bool) {
        self.firstOccurrenceDate = assumedDate
        self.occurrenceDate = assumedDate
        self.isAllDay = isAllDay
    }

    public init(assumedDate: Date?,
                occurrenceDate: Date?,
                isAllDay: Bool) {
        self.firstOccurrenceDate = assumedDate
        self.occurrenceDate = occurrenceDate
        self.isAllDay = isAllDay
    }

    public var date: Date? {
        get {
            if isAllDay {
                return occurrenceDate?.startOfDay
            } else {
                return occurrenceDate
            }
        }
        set {
            if firstOccurrenceDate == nil {
                firstOccurrenceDate = newValue
            }
            occurrenceDate = newValue
        }
    }
    
    public func difference(to value: DatePreferences) -> TimeInterval? {
        guard let lhs = self.date,
            let rhs = value.date else { return nil }
        
        switch (self.isAllDay, value.isAllDay) {
        case (true, false):
            return rhs.timeIntervalSince(lhs)

        case (false, true):
            return lhs.timeIntervalSince(rhs)

        default:
            return nil
        }
    }

    public enum CodingKeys: String, CodingKey {
        case firstOccurrenceDate
        case occurrenceDate
        case isAllDay
    }
}

extension DatePreferences: CustomStringConvertible {
    public var description: String {
        if let date = occurrenceDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = isAllDay ? .none : .short
            return dateFormatter.string(from: date)
        }
        return "No date"
    }
    
    public var endPointDescription: String? {
        guard let endPoint = date else { return nil }
        let dateDifference = Calendar.current.taskem_dateDifference(from: Date.now.startOfDay, to: endPoint.startOfDay)
        
        let dayCount = dateDifference.day!
        let monthCount = dateDifference.month!
        let yearCount = dateDifference.year!
        
        var description = ""
        
        if dayCount > 0 || monthCount > 0 || yearCount > 0 {
            description = "in"
            if yearCount > 0 {
                description += " \(yearCount)"
                description += yearCount == 1 ? " year" : " years"
            }
            
            if monthCount > 0 {
                if yearCount != 0 {
                    description += ","
                }
                description += " \(monthCount)"
                description += monthCount == 1 ? " month" : " months"
            }
            
            if yearCount == 0, dayCount > 0 {
                if monthCount != 0 {
                    description += ","
                }
                description += " \(dayCount)"
                description += dayCount == 1 ? " day" : " days"
            }
        }
        return description
    }
}
