//
//  Reminder.swift
//  TaskemFoundation
//
//  Created by Wilson on 27.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct Reminder: Codable, Identifiable, Equatable {
    public var id: EntityId
    public var trigger: ReminderTrigger
    
    public init() {
        self.init(
            id: .auto(),
            trigger: .init()
        )
    }

    public init(id: EntityId,
                trigger: ReminderTrigger) {
        self.id = id
        self.trigger = trigger
    }
    
    public var remindDate: Date? {
        return trigger.remindDate
    }
    
    public var relativeOffset: TimeInterval {
        return trigger.relativeOffset
    }
    
    public var isOn: Bool {
        return trigger.absoluteDate != nil
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case trigger
    }
}

extension Reminder: CustomStringConvertible {
    public var description: String {
        let timeFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            return dateFormatter
        }()
        
        if isOn, let remindDate = remindDate {
            if remindDate == remindDate.startOfDay {
                return timeFormatter.string(from: remindDate)
            } else {
                let rule = ReminderRule(trigger: trigger)
                switch rule {
                case .customUsingDayTime:
                    return timeFormatter.string(from: remindDate)
                default:
                    return rule.description
                }
            }
        }
        return "None"
    }
}
