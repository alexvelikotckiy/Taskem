//
//  Calendar+Helpers.swift
//  TaskemFoundation
//
//  Created by Wilson on 02.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public extension Calendar {

    func taskem_nextPresentDate(after date: Date, firstTrack: Date, component: Calendar.Component) -> Date? {
        switch component {
        case .second, .minute, .hour:
            return self.taskem_nextPresentDateWithSmallComponents(after: date)
        case .year, .month, .day:
            return self.taskem_nextPresentDateWithHighComponents(after: date, firstTrack: firstTrack, component: component)
        case .weekday:
            return self.taskem_nextPresentWeekday(after: date)
        default:
            return nil
        }
    }

    func taskem_nextPresentDateWithSmallComponents(after date: Date) -> Date {
        let differenceDateToPresent = self.dateComponents([.day], from: Date.now, to: date).value(for: .day)!
        if differenceDateToPresent < 0 {
            let presentDate = self.date(byAdding: .day, value: abs(differenceDateToPresent), to: date)!
            return presentDate > DateProvider.current.now ? presentDate : presentDate.tomorrow
        } else {
            return self.date(byAdding: .day, value: 1, to: date)!
        }
    }

    func taskem_nextPresentDateWithHighComponents(after date: Date, firstTrack: Date, component: Calendar.Component) -> Date {
        let differenceToDate = self.dateComponents([component], from: firstTrack, to: date).value(for: component)!
        return self.date(byAdding: component, value: differenceToDate + 1, to: firstTrack)!
    }

    func taskem_nextPresentWeekday(after date: Date) -> Date? {
        return taskem_nextPresentDate(using: allWeekdays, after: date)
    }

    func taskem_nextPresentDate(using listOfDays: Set<Int>, after date: Date) -> Date? {
        if listOfDays.isEmpty { return nil }
        
        let present = date
        var result: Date?
        
        let components = self.dateComponents([.hour, .minute, .second], from: present)
        enumerateDates(startingAfter: present, matching: components, matchingPolicy: .nextTime) { interimDate, idx, stop in
            if let date = interimDate, date > present, idx {
                if listOfDays.contains(date.weekday) {
                    result = date
                    stop = true
                }
            } else {
                stop = true
            }
        }
        return result
    }
    
    private func getWeekDaysInEnglish() -> [String] {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        calendar.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return calendar.weekdaySymbols
    }

    func taskem_getDay(direction: SearchDirection, _ dayName: String, considerToday consider: Bool = false) -> Date {
        let weekdaysName = getWeekDaysInEnglish()
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        let nextWeekDayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        let today = DateProvider.current.now
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

        if consider && calendar.component(.weekday, from: today) == nextWeekDayIndex {
            return today
        }
        let nextDateComponent = NSDateComponents()
        nextDateComponent.weekday = nextWeekDayIndex
        let date = calendar.nextDate(after: today as Date, matching: nextDateComponent as DateComponents, options: direction.calendarOptions)
        return date!
    }

    func taskem_dateFromDays(_ date: Date, days: Int) -> Date {
        return self.date(byAdding: .day, value: days, to: date)!
    }

    func taskem_generateDays(_ interval: DateInterval) -> [Date] {
        var dates: [Date] = []
        var current = interval.start.startOfDay

        while current.compare(interval.end) != .orderedDescending {
            dates.append(current.startOfDay)
            current = self.taskem_dateFromDays(current, days: 1).startOfDay
        }
        return dates
    }

    func taskem_generateDateArray(from date: Date, daysToGenerate days: Int, direction: SearchDirection) -> [Date] {
        let daysToGenerate = abs(days)
        if daysToGenerate == 0 {
            return []
        }
        switch direction {
        case .forward:
            let end = date.dateFromDays(daysToGenerate)
            return taskem_generateDays(.init(start: date, end: end))
            
        case .backward:
            let start = date.dateFromDays(-daysToGenerate)
            return taskem_generateDays(.init(start: start, end: date))
            
        @unknown default:
            fatalError()
        }
    }
    
    func taskem_generateDateArray(from date: Date, range: ClosedRange<Int>) -> [Date] {
        guard range.lowerBound < range.upperBound, range.lowerBound <= 0, range.upperBound >= 0 else { return [] }
        return [taskem_generateDateArray(from: date, daysToGenerate: range.lowerBound, direction: .backward),
                taskem_generateDateArray(from: date, daysToGenerate: range.upperBound, direction: .forward)].flatMap { $0 }.unique().sorted()
    }

    func taskem_dateDifference(from startDate: Date, to date: Date) -> DateComponents {
        return self.dateComponents([.day, .month, .year, .hour, .minute, .second], from: startDate, to: date)
    }
}

public extension Calendar {
    
    func taskem_nearestMorning(after date: Date) -> Date {
        if date < date.morning {
            return date.morning
        }
        return date.tomorrow.morning
    }
    
    func taskem_nearestNoon(after date: Date) -> Date {
        if date < date.noon {
            return date.noon
        }

        return date.tomorrow.noon
    }
    
    func taskem_nearestEvening(after date: Date) -> Date {
        if date < date.evening {
            return date.evening
        }
        return date.tomorrow.evening
    }

    func taskem_nearestLateEvening(after date: Date) -> Date {
        if date < date.lateEvening {
            return date.lateEvening
        }
        return date.tomorrow.lateEvening
    }
    
    func taskem_nearestNight(after date: Date) -> Date {
        if date < date.endOfDay {
            return date.endOfDay
        }
        return date.tomorrow.endOfDay
    }
    
    func taskem_nextNearestWeekday(after date: Date) -> Date? {
        if let currentWeekendInterval = self.dateIntervalOfWeekend(containing: date) {
            return self.date(bySettingHour: date.hour, minute: date.minutes, second: date.seconds, of: currentWeekendInterval.end)
        }

        if let nextWeekendInterval = self.nextWeekend(startingAfter: date) {
            if nextWeekendInterval.contains(date.tomorrow) {
                return self.date(bySettingHour: date.hour, minute: date.minutes, second: date.seconds, of: nextWeekendInterval.end)
            } else {
                return date.tomorrow
            }
        }
        return nil
    }
    
    func taskem_nextNearestWeekend(after date: Date) -> Date? {
        if let currentWeekendInterval = self.dateIntervalOfWeekend(containing: date) {
            if self.isDate(date, inSameDayAs: currentWeekendInterval.start) {
                return date.tomorrow
            }
        }

        if let nextWeekendInterval = self.nextWeekend(startingAfter: date) {
            return self.date(bySettingHour: date.hour, minute: date.minutes, second: date.seconds, of: nextWeekendInterval.start)
        }
        return nil
    }
    
    func taskem_isDayBefore(date: Date, to value: Date) -> Bool {
        let comparison = self.taskem_compareByDays(date: date, to: value)
        let result = comparison == .orderedAscending
        return result
    }
    
    func taskem_isDayInToday(date: Date) -> Bool {
        return isDate(date, inSameDayAs: Date.now)
    }
    
    func taskem_isDayInTomorrow(date: Date) -> Bool {
        return isDate(date, inSameDayAs: Date.now.tomorrow)
    }
    
    func taskem_isDayAfter(date: Date, to value: Date) -> Bool {
        let comparison = self.taskem_compareByDays(date: date, to: value)
        let result = comparison == .orderedDescending
        return result
    }
    
    func taskem_isSameDay(date: Date, in value: Date) -> Bool {
        return taskem_compareByDays(date: date, to: value) == .orderedSame
    }
    
    func taskem_validateIfDateBeforeEndDate(_ date: Date?, end: Date?) -> Date? {
        if let newDate = date {
            if let endDate = end {
                if newDate < endDate {
                    return newDate
                }
            } else {
                return newDate
            }
        }
        return nil
    }

    func taskem_compareByDays(date: Date, to value: Date) -> ComparisonResult {
        var result = self.compare(date, to: value, toGranularity: .year)

        if result == ComparisonResult.orderedSame {
            result = self.compare(date, to: value, toGranularity: .month)

            if result == ComparisonResult.orderedSame {
                result = self.compare(date, to: value, toGranularity: .day)
            }
        }

        return result
    }
    
    func taskem_setting(components: [Calendar.Component], to date: Date, from value: Date) -> Date? {
        var dateComponents = self.dateComponents(in: TimeZone.current, from: date)
        for component in components {
            if component == .year {
                dateComponents.setValue(self.component(component, from: value), for: .yearForWeekOfYear)
            }
            dateComponents.setValue(self.component(component, from: value), for: component)
        }
        return self.date(from: dateComponents)
    }
    // TODO: Test
    func taskem_dateDifferenceToNowDescription(date: Date) -> String {
        if isDateInToday(date) {
            return "Today"
        } else if isDateInTomorrow(date) {
            return "Tomorrow"
        } else if isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let now = DateProvider.current.now

            let yearDiff = abs(dateComponents([.year], from: now, to: date).year!)
            let monthDiff = abs(dateComponents([.month], from: now, to: date).month!)
            let dayDiff = abs(dateComponents([.day], from: now, to: date).day!)
            let hourDiff = abs(dateComponents([.hour], from: now, to: date).hour!)
            let minuteDiff = abs(dateComponents([.minute], from: now, to: date).minute!)

            var subtitle = ""
            if yearDiff > 0 {
                subtitle = "\(yearDiff) year"
                subtitle += yearDiff == 1 ? "" : "s"
            } else if monthDiff > 0 {
                subtitle = "\(monthDiff) month"
                subtitle += monthDiff == 1 ? "" : "s"
            } else if dayDiff > 0, yearDiff == 0 || monthDiff == 0 {
                subtitle = " \(dayDiff) day"
                subtitle += dayDiff == 1 ? "" : "s"
            } else if dayDiff == 0, yearDiff == 0, monthDiff == 0 {
                subtitle = " \(hourDiff) hour"
                subtitle += hourDiff == 1 ? "" : "s"
            } else {
                subtitle = " \(minuteDiff) minute"
                subtitle += minuteDiff == 1 ? "" : "s"
            }

            if taskem_isDayBefore(date: date, to: now.yesterday) {
                subtitle += " ago"
            } else {
                subtitle = "in " + subtitle
            }
            return subtitle
        }
    }

}

extension Calendar {

    public func weekdaysShortSymbols(for daysOfWeek: Set<Int>) -> [String] {
        let daysArray = daysOfWeek.array.sorted().filter { $0 >= 1 }.filter { $0 <= 7 }.map { $0 - 1 }
        let symbols = self.shortWeekdaySymbols
        return symbols[daysArray]
    }
    // 1, 2, ..., 7 - Sunday, ..., Saturday
    public var allDaysOfWeek: Set<Int> {
        let range = self.range(of: .weekday, in: .month, for: DateProvider.current.now).unsafelyUnwrapped
        return Set(range.lowerBound..<range.upperBound)
    }
    // 2, 3, ..., 6 - Monday, ..., Friday
    public var allWeekdays: Set<Int> {
        let result = self.taskem_weekdays(startDate: Date.now)
        return result
    }
    // 1, 7 - Sunday, Saturday
    public var allWeekends: Set<Int> {
        let result = self.taskem_weekends(startDate: Date.now)
        return result
    }
    
    public func taskem_validateDaysOfWeek(_ daysOfWeek: Set<Int>) -> Set<Int> {
        return daysOfWeek.filter { $0 >= 1 && $0 <= 7 }
    }

    private func taskem_weekdays(startDate: Date) -> Set<Int> {
        return taskem_weekdaysIndexes(startDate: startDate, { $0.isWeekday })
    }
    
    private func taskem_weekends(startDate: Date) -> Set<Int> {
        return taskem_weekdaysIndexes(startDate: startDate, { $0.isWeekend })
    }
    
    private func taskem_weekdaysIndexes(startDate: Date, _ predicate: (Date) -> Bool) -> Set<Int> {
        var result = Set<Int>()
        let dateComponents = self.dateComponents([.hour, .minute, .second], from: startDate)
        self.enumerateDates(startingAfter: startDate, matching: dateComponents, matchingPolicy: .strict) { interimDate, _, stop in
            if let date = interimDate {
                if predicate(date) {
                    result.insert(date.weekday)
                }
                if date > startDate.nextWeek {
                    stop = true
                }
            } else {
                stop = true
            }
        }
        return result
    }
}

extension Calendar.SearchDirection {
    var calendarOptions: NSCalendar.Options {
        switch self {
        case .forward:
            return .matchNextTime
        case .backward:
            return [.searchBackwards, .matchNextTime]
        @unknown default:
            fatalError()
        }
    }
}
