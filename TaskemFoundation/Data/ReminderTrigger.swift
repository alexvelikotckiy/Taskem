//
//  ReminderTrigger.swift
//  TaskemFoundation
//
//  Created by Wilson on 2/23/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

public struct ReminderTrigger: Equatable, Codable {
    public var absoluteDate: Date?
    public var relativeOffset: TimeInterval
    
    public var remindDate: Date? {
        return absoluteDate?.addingTimeInterval(relativeOffset)
    }
    
    public init() {
        self.absoluteDate = nil
        self.relativeOffset = 0
    }
    
    public init(absoluteDate: Date?,
                relativeOffset: TimeInterval) {
        self.absoluteDate = absoluteDate
        self.relativeOffset = relativeOffset
    }
    
    public init(absoluteDate: Date?,
                rule: ReminderRule) {
        guard let absoluteDate = absoluteDate else { self.init(); return }
        
        switch rule {
        case .none:
            self.init()
            
        case .customUsingDayTime:
            self.init(absoluteDate: absoluteDate, relativeOffset: 0)
            
        default:
            self.init(absoluteDate: absoluteDate, relativeOffset: rule.relativeOffset ?? 0)
        }
    }

    public enum CodingKeys: String, CodingKey {
        case absoluteDate
        case relativeOffset
    }
}

public extension ReminderTrigger {
    mutating func change(absoluteDate: Date?, rule: ReminderRule) {
        self = ReminderTrigger(absoluteDate: absoluteDate, rule: rule)
    }
    
    mutating func change(absoluteDate: Date?, dayTime: Date) {
        guard let absoluteDate = absoluteDate,
            let absoluteDateDayTime = Calendar.current.setHourMinuteToDate(to: absoluteDate, time: dayTime) else { self = .init(); return }
        
        self.absoluteDate = absoluteDate
        self.relativeOffset = absoluteDateDayTime.timeIntervalSince(absoluteDate).rounded()
    }
    
    mutating func change(absoluteDate: Date?) {
        let rule = ReminderRule(trigger: self)
        switch rule {
        case .none, .customUsingDayTime:
            self.absoluteDate = absoluteDate
            self.relativeOffset = (rule == .none ? 0 : self.relativeOffset).rounded()
            
        default:
            self.change(absoluteDate: absoluteDate, rule: rule)
        }
    }
    
    mutating func validate(isAllDay: Bool) {
        guard isAllDay else { return }
        
        switch true {
        case relativeOffset < 0:
            self.relativeOffset = 0
            
        case relativeOffset > 86400:
            self.relativeOffset = 86400
            
        default:
            break
        }
    }
}

private extension Calendar {
    func setHourMinuteToDate(to date: Date, time: Date) -> Date? {
        return taskem_setting(components: [.day, .month, .year], to: time, from: date)
    }
}
