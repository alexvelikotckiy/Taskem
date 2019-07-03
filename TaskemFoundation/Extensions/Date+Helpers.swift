//
//  Date+Helpers.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public extension Date {

    var currentCalendar: Calendar {
        return Calendar.current
    }

    var seconds: Int {
        return currentCalendar.component(.second, from: self)
    }

    var minutes: Int {
        return currentCalendar.component(.minute, from: self)
    }

    var hour: Int {
        return currentCalendar.component(.hour, from: self)
    }

    var day: Int {
        return currentCalendar.component(.day, from: self)
    }

    var weekday: Int {
        return currentCalendar.component(.weekday, from: self)
    }

    var month: Int {
        return currentCalendar.component(.month, from: self)
    }

    var year: Int {
        return currentCalendar.component(.year, from: self)
    }

    var startOfDay: Date {
        return currentCalendar.startOfDay(for: self)
    }

    var endOfDate: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return currentCalendar.date(byAdding: components, to: self.startOfDay)!
    }

    var morning: Date {
        let userPref = UserPreferences.current
        return currentCalendar.date(bySettingHour: userPref.morning.hour, minute: userPref.morning.minute, second: 0, of: self)!
    }

    var noon: Date {
        let userPref = UserPreferences.current
        return currentCalendar.date(bySettingHour: userPref.noon.hour, minute: userPref.noon.minute, second: 0, of: self)!
    }

    var evening: Date {
        let userPref = UserPreferences.current
        return currentCalendar.date(bySettingHour: userPref.evening.hour, minute: userPref.evening.minute, second: 0, of: self)!
    }
    
    var lateEvening: Date {
        return currentCalendar.date(bySettingHour: 22, minute: 0, second: 0, of: self)!
    }

    var endOfDay: Date {
        return currentCalendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    var tomorrow: Date {
        return currentCalendar.date(byAdding: .day, value: 1, to: self)!
    }

    var yesterday: Date {
        return currentCalendar.date(byAdding: .day, value: -1, to: self)!
    }

    var nextWeek: Date {
        return currentCalendar.date(byAdding: .weekOfMonth, value: 1, to: self)!
    }

    var previousWeek: Date {
        return currentCalendar.date(byAdding: .weekOfMonth, value: -1, to: self)!
    }

    var nextMonth: Date {
        return currentCalendar.date(byAdding: .month, value: 1, to: self)!
    }
    
    var nextYear: Date {
        return currentCalendar.date(byAdding: .year, value: 1, to: self)!
    }

    var previousMonth: Date {
        return currentCalendar.date(byAdding: .month, value: -1, to: self)!
    }

    var nextMonday: Date {
        return currentCalendar.taskem_getDay(direction: .forward, "Monday")
    }

    var isWeekday: Bool {
        return !self.isWeekend
    }

    var isWeekend: Bool {
        return currentCalendar.isDateInWeekend(self)
    }

    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let result = dateFormatter.string(from: self)
        return result
    }

    func addingDays(_ value: Int) -> Date {
        return currentCalendar.taskem_dateFromDays(self, days: value)
    }
    
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let result = dateFormatter.string(from: self)
        return result
    }

    func dateFromDays(_ days: Int) -> Date {
        return currentCalendar.date(byAdding: .day, value: days, to: self)!
    }

    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}
