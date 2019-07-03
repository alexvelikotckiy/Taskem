//
//  ReminderRule.swift
//  TaskemFoundation
//
//  Created by Wilson on 2/23/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

public enum ReminderRule: Int, Codable, CustomStringConvertible, CaseIterable {
    case none = 0
    
    case atEventTime
    case fiveMinutesBefore
    case halfHourBefore
    case oneHourBefore
    case oneDayBefore
    case oneWeekBebore
    
    case customUsingDayTime
    
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .atEventTime:
            return "At event time"
        case .fiveMinutesBefore:
            return "5 minutes before"
        case .halfHourBefore:
            return "30 minutes before"
        case .oneHourBefore:
            return "1 hour before"
        case .oneDayBefore:
            return "1 day before"
        case .oneWeekBebore:
            return "1 week before"
        case .customUsingDayTime:
            return "Custom"
        }
    }
    
    public init(reminder: Reminder) {
        self.init(trigger: reminder.trigger)
    }
    
    public init(trigger: ReminderTrigger) {
        guard trigger.absoluteDate != nil else { self = .none; return }
        
        let roundedRelativeOffset = trigger.relativeOffset.rounded()
        
        switch roundedRelativeOffset {
        case 0:
            self = .atEventTime
        case -300:
            self = .fiveMinutesBefore
        case -1800:
            self = .halfHourBefore
        case -3600:
            self = .oneHourBefore
        case -86400:
            self = .oneDayBefore
        case -604800:
            self = .oneWeekBebore
        default:
            self = .customUsingDayTime
        }
    }
    
    public var relativeOffset: TimeInterval? {
        let result: TimeInterval?
        switch self {
        case .none:
            result = nil
        case .atEventTime:
            result = 0
        case .fiveMinutesBefore:
            result = -300
        case .halfHourBefore:
            result = -1800
        case .oneHourBefore:
            result = -3600
        case .oneDayBefore:
            result = -86400
        case .oneWeekBebore:
            result = -604800
        case .customUsingDayTime:
            result = nil
        }
        return result?.rounded()
    }
}
