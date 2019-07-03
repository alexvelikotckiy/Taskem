//
//  RepeatPreferences.swift
//  TaskemFoundation
//
//  Created by Wilson on 02.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct RepeatPreferences: Codable, Equatable {
    public var rule: RepeatRule
    // Must be optional
    // reason: a parsing bug on FirebaseCodable.framework
    public var _daysOfWeek: Set<Int>?
    public var endDate: Date?
    
    public var isOn: Bool {
        return rule != .none
    }
    
    public var daysOfWeek: Set<Int> {
        get { return _daysOfWeek ?? .init() }
        set { _daysOfWeek = newValue }
    }
    
    public init() {
        self.rule = .none
        self.daysOfWeek = .init()
    }

    public init(rule: RepeatRule) {
        self.rule = rule
        self.daysOfWeek = rule.standardTrackDaysOfWeek
    }

    public init(rule: RepeatRule,
                daysOfWeek: Set<Int>,
                endDate: Date?) {
        self.rule = rule
        self.endDate = endDate
        self.daysOfWeek = Calendar.current.taskem_validateDaysOfWeek(daysOfWeek)
        
        self.validate()
    }
    
    public func nextRepeatDate(firstTrack start: Date,
                               currentTrack current: Date) -> Date? {
        var repeatPref = self
        repeatPref.validate()
        
        var nextDate: Date?
        
        switch repeatPref.rule {
        case .none:
            nextDate = nil
            
        case .daily:
            nextDate = Calendar.current.taskem_nextPresentDateWithSmallComponents(after: current)
            
        case .weekly:
            nextDate = Calendar.current.taskem_nextPresentDate(using: repeatPref.daysOfWeek, after: current)
            
        case .monthly, .yearly:
            nextDate = Calendar.current.taskem_nextPresentDate(after: current, firstTrack: start, component: repeatPref.rule == .monthly ? .month : .year)
        }
        return Calendar.current.taskem_validateIfDateBeforeEndDate(nextDate, end: repeatPref.endDate)
    }
    
    public enum CodingKeys: String, CodingKey {
        case rule
        case _daysOfWeek
        case endDate
    }
}

extension RepeatPreferences: CustomStringConvertible {
    public var description: String {
        var result = "Every"
        switch self.rule {
        case .none:
            return "No repeat"
        case .daily:
            result += " day"
        case .weekly:
            if daysOfWeek.count == 0 {
                return "No Repeat"
            } else if daysOfWeek.count == 1 {
                result += " week"
            } else {
                Calendar.current.weekdaysShortSymbols(for: daysOfWeek).forEach {
                    result += " \($0),"
                }
                result.removeLast()
            }
        case .monthly:
            result += " month"
        case .yearly:
            result += " year"
        }
        if let endDate = endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            result += " till " + dateFormatter.string(from: endDate)
        }
        return result
    }
    
    public var repeatDescription: String {
        var result = "Every"
        switch self.rule {
        case .none:
            return "No Repeat"
        case .daily:
            result += " day"
        case .weekly:
            if daysOfWeek.count == 0 {
                return "No Repeat"
            } else if daysOfWeek.count == 1 {
                result += " week"
            } else {
                Calendar.current.weekdaysShortSymbols(for: daysOfWeek).forEach {
                    result += " \($0),"
                }
                result.removeLast()
            }
        case .monthly:
            result += " month"
        case .yearly:
            result += " year"
        }
        return result
    }
    
    public var endPointDescription: String? {
        guard let endDate = endDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        return "Till " + dateFormatter.string(from: endDate)
    }
}

public extension RepeatPreferences {
    mutating func validate() {
        change(rule: self.rule)
    }
    
    mutating func change(rule: RepeatRule) {
        let endDate = self.endDate
        let daysOfWeek = self.daysOfWeek
        self = RepeatPreferences(rule: rule)

        switch rule {
        case .none:
            self.daysOfWeek = .init()
            self.endDate = nil

        case .weekly:
            self.daysOfWeek = Calendar.current.taskem_validateDaysOfWeek(daysOfWeek)
            self.endDate = endDate

        case .daily, .monthly, .yearly:
            self.daysOfWeek = rule.standardTrackDaysOfWeek
            self.endDate = endDate
        }
    }
}
