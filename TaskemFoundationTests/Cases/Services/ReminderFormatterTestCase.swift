//
//  ReminderFormatterTest.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import Nimble
import TaskemFoundation

class ReminderFormatterTestCase: XCTestCase {
        
    private typealias Trigger = ReminderTrigger
    private typealias Rule = ReminderRule
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    func testShouldReturnEmptyTriggerWhenAbsoluteDateIsNil() {
        var trigger = Trigger()
        
        trigger.change(absoluteDate: nil, dayTime: Date.now)

        expectEmptyTrigger(trigger)
    }
    
    func testResolveTriggerUsingDayTime() {
        var trigger = Trigger()
        let absoluteDate = Date.now
        let dayTime = Calendar.current.date(bySettingHour: 10, minute: 20, second: 30, of: absoluteDate)!
        
        trigger.change(absoluteDate: absoluteDate, dayTime: dayTime)
        
        expect(trigger.absoluteDate!.timeless) == absoluteDate.timeless
        expect(trigger.remindDate!.hour) == 10
        expect(trigger.remindDate!.minutes) == 20
    }
    
    func testResolveNextTriggerFromEmptyTrigger() {
        let emptyTrigger = Trigger(absoluteDate: nil, relativeOffset: 0)
        let nextAbsoluteDate = Date.now.tomorrow
        var trigger = emptyTrigger
        
        trigger.change(absoluteDate: nextAbsoluteDate)
        
        expectTriggerValues(trigger, absoluteDate: nextAbsoluteDate, relativeOffset: 0)
    }
    
    func testResolveNextTriggerFromOldTrigger() {
        let oldTrigger = Trigger(absoluteDate: Date.now, relativeOffset: -300)
        let nextAbsoluteDate = Date.now.tomorrow
        var trigger = oldTrigger
        
        trigger.change(absoluteDate: nextAbsoluteDate)
        
        expectTriggerValues(trigger, absoluteDate: nextAbsoluteDate, relativeOffset: -300)
    }
    
    func testResolveNextTriggerFromOldCustomDayTimeTrigger() {
        let oldTrigger = Trigger(absoluteDate: Date.now, relativeOffset: -1)
        let nextAbsoluteDate = Date.now.tomorrow
        var trigger = oldTrigger
        
        trigger.change(absoluteDate: nextAbsoluteDate)
        
        expectTriggerValues(trigger, absoluteDate: nextAbsoluteDate, relativeOffset: -1)
    }
    
    func testResolveTriggerUsingRemindRules() {
        let absoluteDate = Date.now
        
        let triggerFiveMinutesBefore = ReminderTrigger(absoluteDate: absoluteDate, rule: .fiveMinutesBefore)
        let triggerUsingDayTime = ReminderTrigger(absoluteDate: absoluteDate, rule: .customUsingDayTime)
        let triggerNone = ReminderTrigger(absoluteDate: absoluteDate, rule: .none)
        
        expectTriggerValues(triggerFiveMinutesBefore, absoluteDate: absoluteDate, relativeOffset: -300)
        expectTriggerValues(triggerUsingDayTime, absoluteDate: absoluteDate, relativeOffset: 0)
        expectTriggerValuesNilAbsoluteDate(triggerNone, relativeOffset: 0)
    }
    
    func testShouldRoundRelativeOffset() {
        var trigger = Trigger(absoluteDate: Date.now, relativeOffset: -1.1)
        
        trigger.change(absoluteDate: Date.now)
        
        expectRoundedRelativeOffset(trigger)
    }
    
    func testShouldResolveReminderRules() {
        let triggerAtTimeEvent = Trigger(absoluteDate: Date.now, relativeOffset: 0)
        let triggerFiveMinutesBefore = Trigger(absoluteDate: Date.now, relativeOffset: -300)
        let triggerHalfHourBefore = Trigger(absoluteDate: Date.now, relativeOffset: -1800)
        let triggerOneHourBefore = Trigger(absoluteDate: Date.now, relativeOffset: -3600)
        let triggerOneDayBefore = Trigger(absoluteDate: Date.now, relativeOffset: -86400)
        let triggerOneWeekBebore = Trigger(absoluteDate: Date.now, relativeOffset: -604800)
        let triggerCustomUsingDayTime = Trigger(absoluteDate: Date.now, relativeOffset: -1)
        
        let ruleAtTimeEvent = Rule(trigger: triggerAtTimeEvent)
        let ruleFiveMinutesBefore = Rule(trigger: triggerFiveMinutesBefore)
        let ruleHalfHourBefore = Rule(trigger: triggerHalfHourBefore)
        let ruleOneHourBefore = Rule(trigger: triggerOneHourBefore)
        let ruleOneDayBefore = Rule(trigger: triggerOneDayBefore)
        let ruleOneWeekBebore = Rule(trigger: triggerOneWeekBebore)
        let ruleCustomUsingDayTime = Rule(trigger: triggerCustomUsingDayTime)
        
        expectRule(ruleAtTimeEvent, forRule: .atEventTime)
        expectRule(ruleFiveMinutesBefore, forRule: .fiveMinutesBefore)
        expectRule(ruleHalfHourBefore, forRule: .halfHourBefore)
        expectRule(ruleOneHourBefore, forRule: .oneHourBefore)
        expectRule(ruleOneDayBefore, forRule: .oneDayBefore)
        expectRule(ruleOneWeekBebore, forRule: .oneWeekBebore)
        expectRule(ruleCustomUsingDayTime, forRule: .customUsingDayTime)
    }
    
    private func expectRoundedRelativeOffset(_ trigger: Trigger) {
        expect(trigger.relativeOffset).to(equal(trigger.relativeOffset.rounded()))
    }
    
    private func expectTriggerValuesNilAbsoluteDate(_ trigger: Trigger, relativeOffset: TimeInterval) {
        expect(trigger.absoluteDate).to(beNil())
        expect(trigger.relativeOffset).to(equal(relativeOffset))
    }
    
    private func expectTriggerValues(_ trigger: Trigger, absoluteDate: Date, relativeOffset: TimeInterval) {
        expect(trigger.absoluteDate).to(equal(absoluteDate))
        expect(trigger.relativeOffset).to(equal(relativeOffset))
    }
    
    private func expectEmptyTrigger(_ trigger: Trigger) {
        expect(trigger.absoluteDate).to(beNil())
        expect(trigger.relativeOffset).to(equal(0))
    }
    
    private func expectRule(_ rule: Rule, forRule: Rule) {
        expect(rule).to(equal(forRule))
    }
}
