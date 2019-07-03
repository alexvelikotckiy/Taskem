//
//  DatePickerManualViewModel.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DatePickerManualViewModel: AutoEquatable {
    
    public var datePreferences: DatePreferences
    public var mode: Screen

    public enum Screen: Int {
        case calendar = 0
        case time
    }

    public init() {
        self.datePreferences = .init()
        self.mode = .calendar
    }

    public init(datePreferences: DatePreferences, mode: Screen) {
        self.mode = mode
        self.datePreferences = datePreferences
    }
    
    public var isAllDay: Bool {
        return datePreferences.isAllDay
    }
    
    public var date: Date? {
        return datePreferences.date
    }
    
    public var dateTitle: String {
        if let date = datePreferences.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
        return "Set date"
    }
    
    public var timeTitle: String {
        if let date = datePreferences.date, !datePreferences.isAllDay {
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return "Set time"
    }

    public var isOverdueTime: Bool {
        if let date = datePreferences.date,
            date < DateProvider.current.now {
            return true
        }
        return false
    }
    
    public var isOverdueDate: Bool {
        if let date = datePreferences.date,
            date < DateProvider.current.now,
            !Calendar.current.isDateInToday(date) {
            return true
        }
        return false
    }
}
