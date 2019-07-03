
//  RepeatFormatterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

private typealias Rule = RepeatRule

class RepeatFormatterBaseTestCase: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    fileprivate func expectRule(_ repeatPref: RepeatPreferences, rule: Rule, line: UInt = #line) {
        expect(repeatPref.rule, line: line).to(equal(rule))
    }
    
    fileprivate func expectDaysOfWeek(_ repeatPref: RepeatPreferences, daysOfWeek: Set<Int>, line: UInt = #line) {
        expect(repeatPref.daysOfWeek, line: line).to(equal(daysOfWeek))
    }
    
    fileprivate func expectEndDate(_ repeatPref: RepeatPreferences, endDate: Date?, line: UInt = #line) {
        if let endDate = endDate {
            expect(repeatPref.endDate, line: line).to(equal(endDate))
        } else {
            expect(repeatPref.endDate, line: line).to(beNil())
        }
    }
    
    fileprivate func expectRepeatValues(_ repeatPref: RepeatPreferences, rule: Rule, daysOfWeek: Set<Int>, endDate: Date?, line: UInt = #line) {
        expectRule(repeatPref, rule: rule, line: line)
        expectDaysOfWeek(repeatPref, daysOfWeek: daysOfWeek, line: line)
        expectEndDate(repeatPref, endDate: endDate, line: line)
    }
}

class RepeatFormatterValidateDayOfWeekTestCase: RepeatFormatterBaseTestCase {

    func testStandardTrackDaysOfWeek() {
        let allDaysOfWeek = Calendar.current.allDaysOfWeek
        
        let noneTrackDays = RepeatRule.none.standardTrackDaysOfWeek
        let dailyTrackDays = RepeatRule.daily.standardTrackDaysOfWeek
        let weeklyTrackDays = RepeatRule.weekly.standardTrackDaysOfWeek
        let monthlyTrackDays = RepeatRule.monthly.standardTrackDaysOfWeek
        let yearlyTrackDays = RepeatRule.yearly.standardTrackDaysOfWeek
        
        expect(noneTrackDays).to(beEmpty())
        expect(monthlyTrackDays).to(beEmpty())
        expect(yearlyTrackDays).to(beEmpty())
        expect(dailyTrackDays) == allDaysOfWeek
        expect(weeklyTrackDays) == allDaysOfWeek
    }
}

class RepeatFormatterResolveNextDateTestCase: RepeatFormatterBaseTestCase {
    
    private let start = Date.now.yesterday
    private let now = Date.now
    private let endDate = Date.now
    
    func testShouldNotResolveNextDateIfAfterEndDate() {
        let repeatPref = RepeatPreferences(rule: .daily, daysOfWeek: .init(), endDate: endDate)
        
        let repeatDate = repeatPref.nextRepeatDate(firstTrack: start, currentTrack: now)
        
        expect(repeatDate).to(beNil())
    }
    
    // FIXME: Fail on method taskem_nextPresentDateWithDaysOfWeek
    func testResolveNextDate() {
        let noneRepeat = RepeatPreferences(rule: .none)
        let dailyRepeat = RepeatPreferences(rule: .daily)
        let weeklyRepeat = RepeatPreferences(rule: .weekly)
        let monthlyRepeat = RepeatPreferences(rule: .monthly)
        let yearlyRepeat = RepeatPreferences(rule: .yearly)
        
        let noneDate = noneRepeat.nextRepeatDate(firstTrack: start, currentTrack: now)
        let dailyDate = dailyRepeat.nextRepeatDate(firstTrack: start, currentTrack: now)
        let weeklyDate = weeklyRepeat.nextRepeatDate(firstTrack: start, currentTrack: now)
        let monthlyDate = monthlyRepeat.nextRepeatDate(firstTrack: start, currentTrack: now)
        let yearlyDate = yearlyRepeat.nextRepeatDate(firstTrack: start, currentTrack: now)
        
        expect(noneDate).to(beNil())
        expect(dailyDate) == now.tomorrow
        expect(weeklyDate!.timeless) == now.tomorrow.timeless
        expect(monthlyDate) == start.nextMonth
        expect(yearlyDate) == start.nextYear
    }
    
    func testResolveNextDateUsingDaysOfWeek() {
        let start = dateFormatter.date(from: "22.09.2018")! // Saturday
        let current = dateFormatter.date(from: "23.09.2018")! //Sunday
        let daysOfWeek = Set([1]) //Sunday, Tuesday, Saturday
        let repeatPref = RepeatPreferences(rule: .weekly, daysOfWeek: daysOfWeek, endDate: nil)
        
        let repeatDate = repeatPref.nextRepeatDate(firstTrack: start, currentTrack: current)!
        let weekday = Calendar.current.dateComponents([.weekday], from: repeatDate).weekday!
        
        expect(daysOfWeek.contains(weekday)) == true
    }
    
    func testResolveNextDateIfStartDateIsEndOfMonth() {
        let start = dateFormatter.date(from: "31.08.2018")!
        let current = dateFormatter.date(from: "29.09.2018")!
        let expectedDate = dateFormatter.date(from: "30.09.2018")!
        let repeatPref = RepeatPreferences(rule: .monthly, daysOfWeek: .init(), endDate: nil)
        
        let repeatDate = repeatPref.nextRepeatDate(firstTrack: start, currentTrack: current)
        
        expect(repeatDate) == expectedDate
    }
    
    func testResolveNextDateIfCurrentDateIsEndOfMonth() {
        let start = dateFormatter.date(from: "31.08.2018")!
        let current = dateFormatter.date(from: "30.09.2018")!
        let expectedDate = dateFormatter.date(from: "31.10.2018")!
        let repeatPref = RepeatPreferences(rule: .monthly, daysOfWeek: .init(), endDate: nil)
        
        let repeatDate = repeatPref.nextRepeatDate(firstTrack: start, currentTrack: current)
        
        expect(repeatDate) == expectedDate
    }
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }
}

class RepeatFormatterChangeRuleTestCase: RepeatFormatterBaseTestCase {
    
    func testShouldChangeRule() {
        var none = RepeatPreferences(rule: .none)
        var daily = RepeatPreferences(rule: .daily)
        var weekly = RepeatPreferences(rule: .weekly)
        var monthly = RepeatPreferences(rule: .monthly)
        var yearly = RepeatPreferences(rule: .yearly)
        
        none.change(rule: .none)
        daily.change(rule: .daily)
        weekly.change(rule: .weekly)
        monthly.change(rule: .monthly)
        yearly.change(rule: .yearly)
        
        expectRule(none, rule: .none)
        expectRule(daily, rule: .daily)
        expectRule(weekly, rule: .weekly)
        expectRule(monthly, rule: .monthly)
        expectRule(yearly, rule: .yearly)
    }
    
    func testShouldResolveDaysOfWeekAfterChangeRule() {
        let daysOfWeek = Set([1,3,5])
        let allDaysOfWeek = Calendar.current.allDaysOfWeek
        var none = RepeatPreferences(rule: .none, daysOfWeek: daysOfWeek, endDate: nil)
        var daily = RepeatPreferences(rule: .daily, daysOfWeek: daysOfWeek, endDate: nil)
        var weekly = RepeatPreferences(rule: .weekly, daysOfWeek: daysOfWeek, endDate: nil)
        var monthly = RepeatPreferences(rule: .monthly, daysOfWeek: daysOfWeek, endDate: nil)
        var yearly = RepeatPreferences(rule: .yearly, daysOfWeek: daysOfWeek, endDate: nil)
        
        none.change(rule: .none)
        daily.change(rule: .daily)
        weekly.change(rule: .weekly)
        monthly.change(rule: .monthly)
        yearly.change(rule: .yearly)
        
        expectDaysOfWeek(none, daysOfWeek: .init())
        expectDaysOfWeek(daily, daysOfWeek: allDaysOfWeek)
        expectDaysOfWeek(weekly, daysOfWeek: daysOfWeek)
        expectDaysOfWeek(monthly, daysOfWeek: .init())
        expectDaysOfWeek(yearly, daysOfWeek: .init())
    }
    
    func testShouldResolveEndDateAfterChangeRule() {
        let endDate = Date.now.tomorrow
        var none = RepeatPreferences(rule: .none, daysOfWeek: .init(), endDate: endDate)
        var daily = RepeatPreferences(rule: .daily, daysOfWeek: .init(), endDate: endDate)
        var weekly = RepeatPreferences(rule: .weekly, daysOfWeek: .init(), endDate: endDate)
        var monthly = RepeatPreferences(rule: .monthly, daysOfWeek: .init(), endDate: endDate)
        var yearly = RepeatPreferences(rule: .yearly, daysOfWeek: .init(), endDate: endDate)

        none.change(rule: .daily)
        daily.change(rule: .weekly)
        weekly.change(rule: .monthly)
        monthly.change(rule: .yearly)
        yearly.change(rule: .none)

        expectEndDate(none, endDate: nil)
        expectEndDate(daily, endDate: endDate)
        expectEndDate(weekly, endDate: endDate)
        expectEndDate(monthly, endDate: endDate)
        expectEndDate(yearly, endDate: nil)
    }
    
    func testShouldValidateDaysOfWeek() {
        let wrongDays = Set([-1,0,1,5,8])
        let validDays = Set([1,5])
        var weekly = RepeatPreferences(rule: .weekly, daysOfWeek: wrongDays, endDate: nil)
        
        weekly.change(rule: .weekly)
        
        expectRepeatValues(weekly, rule: .weekly, daysOfWeek: validDays, endDate: nil)
    }
    
    func testShouldResetRepeatRule() {
        let wrongDays = Set([-1,0,1,5,8])
        let validDays = Set([1,5])
        let allDaysOfWeek = Calendar.current.allDaysOfWeek
        var daily = RepeatPreferences(rule: .daily, daysOfWeek: wrongDays, endDate: nil)
        var weekly = RepeatPreferences(rule: .weekly, daysOfWeek: wrongDays, endDate: nil)
        
        daily.validate()
        weekly.validate()
        
        expectRepeatValues(daily, rule: .daily, daysOfWeek: allDaysOfWeek, endDate: nil)
        expectRepeatValues(weekly, rule: .weekly, daysOfWeek: validDays, endDate: nil)
    }
}
