//
//  CalendarTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/26/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CalendarTestCase: TaskemTestCaseBase {

    private let calendar = Calendar.current
    
    private var todayMorning: Date {
        return Date.now.morning
    }
    private var todayEvening: Date {
        return Date.now.evening
    }
    private var tomorrow: Date {
        return Date.now.tomorrow
    }
    private var yesterday: Date {
        return Date.now.yesterday
    }
    private var now: Date {
        return Date.now
    }
    
    private var allWeekdays: Set<Int> {
        return calendar.allWeekdays
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    func testFindNextPresentDate() {
        let nextDateUsingHour = calendar.taskem_nextPresentDate(after: now, firstTrack: now, component: .hour)!
        let nextDateUsingDay = calendar.taskem_nextPresentDate(after: now, firstTrack: now, component: .day)!
        let nextDateUsingWeekday = calendar.taskem_nextPresentDate(after: now, firstTrack: now, component: .weekday)!
        let nextDateUsingMonth = calendar.taskem_nextPresentDate(after: now, firstTrack: now, component: .month)!
        let nextDateUsingYear = calendar.taskem_nextPresentDate(after: now, firstTrack: now, component: .year)!
        
        expect(nextDateUsingHour) == now.tomorrow
        expect(nextDateUsingDay) == now.tomorrow
        expect(nextDateUsingMonth) == now.nextMonth
        expect(nextDateUsingYear) == now.nextYear
        expect(self.allWeekdays.contains(nextDateUsingWeekday.weekday)) == true
        expect(nextDateUsingWeekday > self.now) == true
    }
    
    func testFindNextPresentWeekday() {
        let resolvedDate = calendar.taskem_nextPresentWeekday(after: Date.now)!
        
        expect(self.allWeekdays.contains(resolvedDate.weekday)) == true
        expect(resolvedDate > self.now) == true
    }
    
    func testFindNextPresentDateUsingWeekdaysList() {
        let weekdayList = Set([1, 3, 7])

        let resolvedDate = calendar.taskem_nextPresentDate(using: weekdayList, after: Date.now)!
        let weekday = Calendar.current.dateComponents([.weekday], from: resolvedDate).weekday!

        expect(weekdayList.contains(weekday)) == true
        expect(resolvedDate > self.now) == true
    }
    
    func testShouldNotFindNextPresentDateWhenUsingEmptyWeekdaysList() {
        let emptyWeekdayList = Set<Int>()

        let resolvedDate = calendar.taskem_nextPresentDate(using: emptyWeekdayList, after: Date.now)

        expect(resolvedDate).to(beNil())
    }
    
    func testFindNextPresentDateWithHighComponents() {
        let endOfMonth = dateFormatter.date(from: "31.08.2018")!
        let now = dateFormatter.date(from: "01.09.2018")!
        let expectedNextMonth = dateFormatter.date(from: "30.09.2018")!
        let expectedNextYear = dateFormatter.date(from: "31.08.2019")!
        
        let nextMonth = calendar.taskem_nextPresentDateWithHighComponents(after: now, firstTrack: endOfMonth, component: .month)
        let nextYear = calendar.taskem_nextPresentDateWithHighComponents(after: now, firstTrack: endOfMonth, component: .year)
        
        expect(nextMonth) == expectedNextMonth
        expect(nextYear) == expectedNextYear
    }
    
    func testFindNextPresentDateWithSmallComponents() {
        let nextAfterNow = calendar.taskem_nextPresentDateWithSmallComponents(after: now)
        let nextAfterYesterday = calendar.taskem_nextPresentDateWithSmallComponents(after: yesterday.startOfDay)
        let nextAfterTomorrow = calendar.taskem_nextPresentDateWithSmallComponents(after: tomorrow.startOfDay)
        
        expect(nextAfterNow) == now.tomorrow
        expect(nextAfterYesterday) == now.tomorrow.startOfDay
        expect(nextAfterTomorrow) == now.addingDays(2).startOfDay
    }
    
    func testFindDateDifference() {
        let difference = calendar.taskem_dateDifference(from: now.startOfDay, to: now.nextYear.nextMonth.tomorrow.endOfDay)
        
        expect(difference.second!) == 59
        expect(difference.minute!) == 59
        expect(difference.hour!) == 23
        expect(difference.day!) == 1
        expect(difference.month!) == 1
        expect(difference.year!) == 1
    }
    
    func testFindDateByName() {
        let monday = "Monday"
        
        let nextMonday = calendar.taskem_getDay(direction: .forward, monday, considerToday: true)
        let prevMonday = calendar.taskem_getDay(direction: .backward, monday, considerToday: true)
        
        expect(nextMonday.weekday) == 2
        expect(prevMonday.weekday) == 2
        expect(nextMonday.timeless >= self.now.timeless) == true
        expect(prevMonday.timeless <= self.now.timeless) == true
    }
    
    func testGenerateDateArrayUsingDateInterval() {
        let interval = DateInterval(start: yesterday, end: tomorrow)
        
        let dates = calendar.taskem_generateDays(interval)
        
        expect(dates.count) == 3
        expect(dates[0]) == yesterday.startOfDay
        expect(dates[1]) == now.startOfDay
        expect(dates[2]) == tomorrow.startOfDay
    }
    
    func testGenerateDateArrayUsingOneSideRange() {
        let daysToGenerate = 3
        
        let datesEmpty = calendar.taskem_generateDateArray(from: now, daysToGenerate: 0, direction: .forward)
        let datesUpward = calendar.taskem_generateDateArray(from: now, daysToGenerate: daysToGenerate, direction: .forward)
        let datesBackward = calendar.taskem_generateDateArray(from: now, daysToGenerate: -daysToGenerate, direction: .backward)
        
        expect(datesEmpty.count) == 0
        expect(datesUpward.count) == 4
        expect(datesBackward.count) == 4
        expect(datesUpward[0]) == now.startOfDay
        expect(datesUpward[1]) == now.addingDays(1).startOfDay
        expect(datesUpward[2]) == now.addingDays(2).startOfDay
        expect(datesUpward[3]) == now.addingDays(3).startOfDay
        expect(datesBackward[0]) == now.addingDays(-3).startOfDay
        expect(datesBackward[1]) == now.addingDays(-2).startOfDay
        expect(datesBackward[2]) == now.addingDays(-1).startOfDay
        expect(datesBackward[3]) == now.startOfDay
    }
    
    func testGenerateDateArrayUsingDayCountClosedRange() {
        let range = -1...1
        
        let dates = calendar.taskem_generateDateArray(from: now, range: range)
        
        expect(dates.count) == 3
        expect(dates[0]) == now.yesterday.startOfDay
        expect(dates[1]) == now.startOfDay
        expect(dates[2]) == now.tomorrow.startOfDay
    }
    
    func testFindNearestMorning() {
        userPreferences.morning = .init(hour: 1, minute: 0)
        
        let nearestMorningToTodayStartOfDay = calendar.taskem_nearestMorning(after: now.startOfDay)
        let nearestMorningToTodayNight = calendar.taskem_nearestMorning(after: now.endOfDay)
        
        expect(nearestMorningToTodayStartOfDay) == now.morning
        expect(nearestMorningToTodayNight) == now.tomorrow.morning
    }
    
    func testFindNearestNoon() {
        userPreferences.noon = .init(hour: 1, minute: 0)
        
        let nearestNoonToTodayMorning = calendar.taskem_nearestNoon(after: now.morning)
        let nearestNoonToTodayNight = calendar.taskem_nearestNoon(after: now.endOfDay)
        
        expect(nearestNoonToTodayMorning) == now.noon
        expect(nearestNoonToTodayNight) == now.tomorrow.noon
    }
    
    func testFindNearestEvening() {
        userPreferences.evening = .init(hour: 1, minute: 0)
        
        let nearestEveningToTodayMorning = calendar.taskem_nearestEvening(after: now.morning)
        let nearestEveningToTodayNight = calendar.taskem_nearestEvening(after: now.endOfDay)
        
        expect(nearestEveningToTodayMorning) == now.evening
        expect(nearestEveningToTodayNight) == now.tomorrow.evening
    }
    
    func testFindNearestLateEvening() {
        let nearestLateEveningToTodayMorning = calendar.taskem_nearestLateEvening(after: now.morning)
        let nearestLateEveningToTodayNight = calendar.taskem_nearestLateEvening(after: now.endOfDay)
        
        expect(nearestLateEveningToTodayMorning) == now.lateEvening
        expect(nearestLateEveningToTodayNight) == now.tomorrow.lateEvening
    }
    
    func testFindNearestNight() {
        let nearestNightToToday = calendar.taskem_nearestNight(after: now)
        let nearestNightToTodayNight = calendar.taskem_nearestNight(after: now.endOfDay)
        
        expect(nearestNightToToday) == now.endOfDay
        expect(nearestNightToTodayNight) == now.tomorrow.endOfDay
    }
    
    func testFindNextNearestWeekday() {
        let tuesday = dateFormatter.date(from: "27.09.2018")!
        let saturday = dateFormatter.date(from: "29.09.2018")!
        let expectNearestToTuesday = dateFormatter.date(from: "28.09.2018")
        let expectNearestToSaturday = dateFormatter.date(from: "01.10.2018")
        
        let nearestToTuesday = calendar.taskem_nextNearestWeekday(after: tuesday)!
        let nearestToSaturday = calendar.taskem_nextNearestWeekday(after: saturday)!
        
        expect(nearestToTuesday) == expectNearestToTuesday
        expect(nearestToSaturday) == expectNearestToSaturday
    }
    
    func testFindNextNearestWeekend() {
        let tuesday = dateFormatter.date(from: "27.09.2018")!
        let saturday = dateFormatter.date(from: "29.09.2018")!
        let sunday = dateFormatter.date(from: "30.09.2018")!
        let expectNearestToTuesday = dateFormatter.date(from: "29.09.2018")
        let expectNearestToSaturday = dateFormatter.date(from: "30.09.2018")
        let expectNearestToSunday = dateFormatter.date(from: "06.10.2018")
        
        let nearestToTuesday = calendar.taskem_nextNearestWeekend(after: tuesday)!
        let nearestToSaturday = calendar.taskem_nextNearestWeekend(after: saturday)!
        let nearestToSunday = calendar.taskem_nextNearestWeekend(after: sunday)!
        
        expect(nearestToTuesday) == expectNearestToTuesday
        expect(nearestToSaturday) == expectNearestToSaturday
        expect(nearestToSunday) == expectNearestToSunday
    }
    
    func testIsDateBeforeOtherDateIgroneSmallComponens() {
        let comparisonTodayToTodayMorning = calendar.taskem_isDayBefore(date: now, to: todayMorning)
        let comparisonTodayToTomorrow = calendar.taskem_isDayBefore(date: now, to: tomorrow)
        let comparisonTodayToYesterday = calendar.taskem_isDayBefore(date: now, to: yesterday)
        
        expect(comparisonTodayToTodayMorning) == false
        expect(comparisonTodayToTomorrow) == true
        expect(comparisonTodayToYesterday) == false
    }
    
    func testIsDateAfterOtherDateIgroneSmallComponens() {
        let comparisonTodayToTodayMorning = calendar.taskem_isDayAfter(date: now, to: todayMorning)
        let comparisonTodayToTomorrow = calendar.taskem_isDayAfter(date: now, to: tomorrow)
        let comparisonTodayToYesterday = calendar.taskem_isDayAfter(date: now, to: yesterday)
        
        expect(comparisonTodayToTodayMorning) == false
        expect(comparisonTodayToTomorrow) == false
        expect(comparisonTodayToYesterday) == true
    }
    
    func testIsDateInToday() {
        let comparisonTodayToTodayMorning = calendar.taskem_isDayInToday(date: todayMorning)
        let comparisonTodayToTomorrow = calendar.taskem_isDayInToday(date: tomorrow)
        let comparisonTodayToYesterday = calendar.taskem_isDayInToday(date: yesterday)
        
        expect(comparisonTodayToTodayMorning) == true
        expect(comparisonTodayToTomorrow) == false
        expect(comparisonTodayToYesterday) == false
    }
    
    func testIsDateInTomorrow() {
        let comparisonTomorrowToTodayMorning = calendar.taskem_isDayInTomorrow(date: todayMorning)
        let comparisonTomorrowToTomorrow = calendar.taskem_isDayInTomorrow(date: tomorrow)
        let comparisonTomorrowToYesterday = calendar.taskem_isDayInTomorrow(date: yesterday)
        let comparisonTomorrowToDayAfterTomorrow = calendar.taskem_isDayInTomorrow(date: tomorrow.tomorrow)
        
        expect(comparisonTomorrowToTodayMorning) == false
        expect(comparisonTomorrowToTomorrow) == true
        expect(comparisonTomorrowToYesterday) == false
        expect(comparisonTomorrowToDayAfterTomorrow) == false
    }
    
    func testIsDatesInSameDay() {
        let comparisonTodayToTodayMorning = calendar.taskem_isSameDay(date: now, in: todayMorning)
        let comparisonTodayToTomorrow = calendar.taskem_isSameDay(date: now, in: tomorrow)
        
        expect(comparisonTodayToTodayMorning) == true
        expect(comparisonTodayToTomorrow) == false
    }
    
    func testCompateDatesByDate() {
        let comparisonEqual = calendar.taskem_compareByDays(date: todayMorning, to: todayEvening)
        let comparisonAscending = calendar.taskem_compareByDays(date: now, to: tomorrow)
        let comparisonDescending = calendar.taskem_compareByDays(date: now, to: yesterday)
        
        expect(comparisonEqual) == .orderedSame
        expect(comparisonAscending) == .orderedAscending
        expect(comparisonDescending) == .orderedDescending
    }
    
    func testSettingCalendarComponents() {
        let components: [Calendar.Component] = [.year, .month, .day, .hour, .minute]
        let randomDate = now.addingTimeInterval(12345678)
        
        let expectedToday = calendar.taskem_setting(components: components, to: randomDate, from: now)!
        
        expect(expectedToday.minutes) == now.minutes
        expect(expectedToday.hour) == now.hour
        expect(expectedToday.day) == now.day
        expect(expectedToday.month) == now.month
        expect(expectedToday.year) == now.year
    }
    
    func testDaysOfWeekShouldContainDaysIndexes() {
        let allDaysOfWeek = calendar.allDaysOfWeek
        
        expect(allDaysOfWeek) == Set([1,2,3,4,5,6,7])
    }
    
    func testAllWeekdaysShouldContainOnlyWeekdayIndexes() {
        let allWeekdays = calendar.allWeekdays
        
        expect(allWeekdays) == Set([2,3,4,5,6])
    }
    
    func testAllWeekendsShouldContainOnlyWeekendIndexes() {
        let allWeekdays = calendar.allWeekends
        
        expect(allWeekdays) == Set([1,7])
    }
    
    func testWeekdaySymbols() {
        let daysOfWeek = calendar.allDaysOfWeek
        
        let symbols = calendar.weekdaysShortSymbols(for: daysOfWeek)
        
        expect(symbols.count) == 7
        expect(symbols.contains("Sun")) == true
        expect(symbols.contains("Mon")) == true
        expect(symbols.contains("Tue")) == true
        expect(symbols.contains("Wed")) == true
        expect(symbols.contains("Thu")) == true
        expect(symbols.contains("Fri")) == true
        expect(symbols.contains("Sat")) == true
    }
    
    func testShouldValidateDaysOfWeek() {
        let wrongDays = Set([-1,0,1,5,8])
        let validDays = Set([1,5])
        
        let resolvedDays = calendar.taskem_validateDaysOfWeek(wrongDays)
        
        expect(resolvedDays) == validDays
    }
}
