//
//  TaskFormatterTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class TaskFormatterTestCaseBase: XCTestCase {    
    fileprivate let factory = TaskFactory()
    
    fileprivate let absoluteDate = Date.now
    fileprivate let allDaysOfWeek = Calendar.current.allDaysOfWeek
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }
    
    fileprivate func expectDatePreferencesValues(_ aTask: Task, firstOccurrenceDate: Date?, occurrenceDate: Date?, isAllDay: Bool, line: UInt = #line) {
        let datePref = aTask.datePreference
        expect(datePref.firstOccurrenceDate, line: line).to(firstOccurrenceDate == nil ? beNil() : equal(firstOccurrenceDate))
        expect(datePref.occurrenceDate, line: line).to(occurrenceDate == nil ? beNil() : equal(occurrenceDate))
        expect(datePref.isAllDay, line: line) == isAllDay
    }
    
    fileprivate func expectRemindValues(_ aTask: Task, id: EntityId, absoluteDate: Date?, relativeOffset: TimeInterval, line: UInt = #line) {
        let reminder = aTask.reminder
        expect(reminder.id, line: line) == id
        expect(reminder.trigger.absoluteDate, line: line).to(absoluteDate == nil ? beNil() : equal(absoluteDate))
        expect(reminder.trigger.relativeOffset, line: line) == relativeOffset
    }
    
    fileprivate func expectRepeatValues(_ aTask: Task, rule: RepeatRule, daysOfWeek: Set<Int>, endDate: Date?, line: UInt = #line) {
        let repeatPref = aTask.repeatPreferences
        expectRepeatRule(repeatPref, rule: rule, line: line)
        expectRepeatDaysOfWeek(repeatPref, daysOfWeek: daysOfWeek, line: line)
        expectRepeatEndDate(repeatPref, endDate: endDate, line: line)
    }
    
    fileprivate func expectRepeatRule(_ repeatPref: RepeatPreferences, rule: RepeatRule, line: UInt = #line) {
        expect(repeatPref.rule, line: line) == rule
    }
    
    fileprivate func expectRepeatDaysOfWeek(_ repeatPref: RepeatPreferences, daysOfWeek: Set<Int>, line: UInt = #line) {
        expect(repeatPref.daysOfWeek, line: line) == daysOfWeek
    }
    
    fileprivate func expectRepeatEndDate(_ repeatPref: RepeatPreferences, endDate: Date?, line: UInt = #line) {
        expect(repeatPref.endDate, line: line).to(endDate == nil ? beNil() : equal(endDate))
    }
    
    fileprivate func createRepeat(_ rule: RepeatRule) -> RepeatPreferences {
        return .init(rule: rule)
    }
    
    fileprivate func createDatePref(_ date: Date? = .init(), isAllDay: Bool = false) -> DatePreferences {
        return .init(assumedDate: date, isAllDay: isAllDay)
    }
    
    fileprivate func createReminder(_ absoluteDate: Date? = .init(), offset: TimeInterval = 0) -> Reminder {
        return .init(id: .auto(), trigger: .init(absoluteDate: absoluteDate, relativeOffset: offset))
    }
    
    fileprivate func createTrigger(_ absoluteDate: Date? = .init(), offset: TimeInterval = 0) -> ReminderTrigger {
        return .init(absoluteDate: absoluteDate, relativeOffset: offset)
    }
    
    fileprivate func difference(_ lhs: Date, _ rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSince(rhs)
    }
}

class TaskFormatterTestCase: TaskFormatterTestCaseBase {
    
    func testChangeRepeat() {
        var none = factory.make()
        var daily = factory.make { $0.repeatPreferences = .init(rule: .daily) }
        var weekly = factory.make { $0.repeatPreferences = .init(rule: .weekly) }
        var monthly = factory.make { $0.repeatPreferences = .init(rule: .monthly) }
        var yearly = factory.make { $0.repeatPreferences = .init(rule: .yearly) }

        none.modify(repeat: .daily)
        daily.modify(repeat: .weekly)
        weekly.modify(repeat: .monthly)
        monthly.modify(repeat: .yearly)
        yearly.modify(repeat: .none)
        
        expectRepeatValues(none, rule: .daily, daysOfWeek: allDaysOfWeek, endDate: nil)
        expectRepeatValues(daily, rule: .weekly, daysOfWeek: allDaysOfWeek, endDate: nil)
        expectRepeatValues(weekly, rule: .monthly, daysOfWeek: .init(), endDate: nil)
        expectRepeatValues(monthly, rule: .yearly, daysOfWeek: .init(), endDate: nil)
        expectRepeatValues(yearly, rule: .none, daysOfWeek: .init(), endDate: nil)
    }
    
    func testShouldChangeToUncompleted() {
        let taskWithRepeat = factory.make {
            $0.test_completionDate = Date.now
            $0.repeatPreferences = .init(rule: .daily)
        }
        let taskWithoutRepeat = factory.make {
            $0.test_completionDate = Date.now
        }
        var resolvedWithRepeat = taskWithRepeat
        var resolvedWithoutRepeat = taskWithoutRepeat
        
        resolvedWithRepeat.modify(complete: false)
        resolvedWithoutRepeat.modify(complete: false)
        
        expect(resolvedWithRepeat.datePreference) == taskWithRepeat.datePreference
        expect(resolvedWithoutRepeat.datePreference) == taskWithoutRepeat.datePreference
        expect(resolvedWithRepeat.reminder) == taskWithRepeat.reminder
        expect(resolvedWithoutRepeat.reminder) == taskWithoutRepeat.reminder
        expect(resolvedWithRepeat.completionDate).to(beNil())
        expect(resolvedWithoutRepeat.completionDate).to(beNil())
    }
    
    func testShouldNotUpdateCompletionIfTaskIsAlreadyComplete() {
        let repeatPref = createRepeat(.daily)
        let datePref = createDatePref(absoluteDate)
        let reminder = createReminder(absoluteDate)
        
        let completedTask = factory.make {
            $0.test_completionDate = absoluteDate
            $0.repeatPreferences = repeatPref
            $0.test_datePreference = datePref
            $0.test_reminder = reminder
        }
        let uncompletedTask = factory.make {
            $0.test_completionDate = nil
            $0.repeatPreferences = repeatPref
            $0.test_datePreference = datePref
            $0.test_reminder = reminder
        }
        var resolvedCompleted = completedTask
        var resolvedUnompleted = uncompletedTask
        
        resolvedCompleted.modify(complete: true)
        resolvedUnompleted.modify(complete: false)
        
        expect(resolvedCompleted.reminder) == reminder
        expect(resolvedCompleted.datePreference) == datePref
        expect(resolvedCompleted.completionDate) == absoluteDate
        
        expect(resolvedUnompleted.reminder) == reminder
        expect(resolvedUnompleted.datePreference) == datePref
        expect(resolvedUnompleted.completionDate).to(beNil())
    }
    
    func testShouldNotConsiderRepeatWhenChangeCompletion() {
        let taskWithRepeat = factory.make {
            $0.test_completionDate = nil
            $0.repeatPreferences = .init(rule: .daily)
        }
        let taskWithoutRepeat = factory.make {
            $0.test_completionDate = nil
            $0.repeatPreferences = .init(rule: .none)
        }
        var resolvedWithRepeat = taskWithRepeat
        var resolvedWithoutRepeat = taskWithoutRepeat
        
        resolvedWithRepeat.modify(complete: true, considerRepeat: false)
        resolvedWithoutRepeat.modify(complete: true, considerRepeat: false)
        
        expect(resolvedWithRepeat.datePreference) == taskWithRepeat.datePreference
        expect(resolvedWithoutRepeat.datePreference) == taskWithoutRepeat.datePreference
        expect(resolvedWithRepeat.reminder) == taskWithRepeat.reminder
        expect(resolvedWithoutRepeat.reminder) == taskWithoutRepeat.reminder
        
        expect(resolvedWithRepeat.completionDate?.timeless) == Date.now.timeless
        expect(resolvedWithoutRepeat.completionDate?.timeless) == Date.now.timeless
    }
    
    func testShouldResolveReminderAfterChangeCompletion() {
        let repeatPref = createRepeat(.daily)
        let datePref = createDatePref(absoluteDate, isAllDay: false)
        let datePrefAllDay = createDatePref(absoluteDate, isAllDay: true)
        let reminder = createReminder(absoluteDate, offset: 100)
        
        let task = factory.make {
            $0.repeatPreferences = repeatPref
            $0.test_datePreference = datePref
            $0.test_reminder = reminder
        }
        let taskAllDay = factory.make {
            $0.repeatPreferences = repeatPref
            $0.test_datePreference = datePrefAllDay
            $0.test_reminder = reminder
        }
        var resolvedTask = task
        var resolvedTaskAllDay = taskAllDay
        
        resolvedTask.modify(complete: true)
        resolvedTaskAllDay.modify(complete: true)
        
        expectRemindValues(resolvedTask, id: resolvedTask.reminder.id, absoluteDate: absoluteDate.tomorrow, relativeOffset: 100)
        expectRemindValues(resolvedTaskAllDay, id: resolvedTaskAllDay.reminder.id, absoluteDate: absoluteDate.tomorrow.startOfDay, relativeOffset: 100)
    }
    
    func testShouldResolveDatePreferencesAfterChangeCompletion() {
        let currentDate = Date.now.startOfDay
        let expectedDate = Date.now.startOfDay.tomorrow
        let taskWithDate = factory.make {
            $0.repeatPreferences = .init(rule: .daily)
            $0.test_datePreference = .init(assumedDate: currentDate, isAllDay: false)
        }
        let taskWithoutDate = factory.make {
            $0.repeatPreferences = .init(rule: .daily)
            $0.test_datePreference = .init(assumedDate: nil, isAllDay: false)
        }
        var resolvedWithDate = taskWithDate
        var resolvedWithoutDate = taskWithoutDate
        
        resolvedWithDate.modify(complete: true)
        resolvedWithoutDate.modify(complete: true)
        
        expect(resolvedWithDate.datePreference.date) == expectedDate
        expect(resolvedWithoutDate.datePreference.date).to(beNil())
    }
    
    func testToogleTasksCompletion() {
        let completedTask = factory.make { $0.test_completionDate = Date.now }
        let uncompletedTask = factory.make{ $0.test_completionDate = nil }
        
        let resolvedTasks = [completedTask, uncompletedTask].changeToogleCompletion()
        
        expect(resolvedTasks[0].id) == completedTask.id
        expect(resolvedTasks[1].id) == uncompletedTask.id
        expect(resolvedTasks[0].isComplete) == false
        expect(resolvedTasks[1].isComplete) == true
    }
    
    func testChangeTasksDatePref() {
        let taskOne = factory.make { $0.test_datePreference = .init() }
        let taskTwo = factory.make { $0.test_datePreference = .init(assumedDate: Date.now.morning, isAllDay: false) }
        let datePref = DatePreferences(assumedDate: Date.now, isAllDay: false)
        
        let resolvedTasks = [taskOne, taskTwo].change(datePreferences: datePref)
        
        expect(resolvedTasks[0].id) == taskOne.id
        expect(resolvedTasks[1].id) == taskTwo.id
        expect(resolvedTasks[0].datePreference) == datePref
        expect(resolvedTasks[1].datePreference) == datePref
    }
    
    func testChangeTasksGroupId() {
        let taskOne = factory.make()
        let taskTwo = factory.make()
        let idGroup = EntityId.auto()
        
        let resolvedTasks = [taskOne, taskTwo].change(idGroup: idGroup)
        
        expect(resolvedTasks[0].id) == taskOne.id
        expect(resolvedTasks[1].id) == taskTwo.id
        expect(resolvedTasks[0].idGroup) == idGroup
        expect(resolvedTasks[1].idGroup) == idGroup
    }
    
    func testChangeGroupId() {
        let task = factory.make()
        let idGroup = EntityId.auto()
        
        let resolvedTask = task.change(idGroup: idGroup)
        
        expect(resolvedTask.id) == task.id
        expect(resolvedTask.idGroup) == idGroup
    }
    
    func testChangeToScheduleOvedueStatus() {
        let emptyTask = factory.make()
        let repetableTask = factory.make { $0.repeatPreferences = .init(rule: .daily) }
        
        let resovledEmpty = emptyTask.change(status: .overdue)
        let resovledRepetable = repetableTask.change(status: .overdue)
        
        expect(resovledEmpty) == emptyTask
        expect(resovledRepetable) == repetableTask
    }
    
    func testChangeToScheduleCompleteStatus() {
        let taskWithRepeat = factory.make {
            $0.repeatPreferences = createRepeat(.daily)
            $0.test_datePreference = createDatePref(absoluteDate, isAllDay: false)
            $0.test_reminder = createReminder(absoluteDate, offset: 0)
        }
        let taskWithoutRepeat = factory.make()
        
        let resolvedWithRepeat = taskWithRepeat.change(status: ScheduleSection.complete)
        let resolvedWithoutRepeat = taskWithoutRepeat.change(status: ScheduleSection.complete)
        
        expect(resolvedWithRepeat.datePreference.date) == absoluteDate.tomorrow
        expect(resolvedWithoutRepeat.datePreference) == taskWithoutRepeat.datePreference
        expect(resolvedWithRepeat.reminder.trigger.absoluteDate) == absoluteDate.tomorrow
        expect(resolvedWithoutRepeat.reminder) == taskWithoutRepeat.reminder
        
        expect(resolvedWithRepeat.completionDate).to(beNil())
        expect(resolvedWithoutRepeat.completionDate?.timeless) == Date.now.timeless
    }

    func testChangeToScheduleUnplannedStatus() {
        let task = factory.make {
            $0.test_completionDate = Date.now
            $0.repeatPreferences = createRepeat(.daily)
            $0.test_datePreference = createDatePref(absoluteDate)
        }
        
        let resolvedTask = task.change(status: .unplanned)
        
        expect(resolvedTask.datePreference.date).to(beNil())
        expect(resolvedTask.isComplete) == false
    }
    
    func testChangeToSchedulePlannedStatus() {
        let task = factory.make {
            $0.test_completionDate = Date.now
            $0.repeatPreferences = createRepeat(.daily)
            $0.test_datePreference = createDatePref(absoluteDate)
        }
        
        let resolvedToday = task.change(status: .today)
        let resolvedTomorrow = task.change(status: .tomorrow)
        let resolvedUpcoming = task.change(status: .upcoming)
        
        expect(resolvedToday.isComplete) == false
        expect(resolvedTomorrow.isComplete) == false
        expect(resolvedUpcoming.isComplete) == false
        expect(resolvedToday.datePreference.date?.timeless) == Date.now.timeless
        expect(resolvedTomorrow.datePreference.date?.timeless) == Date.now.tomorrow.timeless
        expect(resolvedUpcoming.datePreference.date?.timeless) == Date.now.tomorrow.tomorrow.timeless
    }
    
    func testChangeToFlatStatus() {
        let completedTask = factory.make { $0.test_completionDate = Date.now }
        let uncompletedTask = factory.make { $0.test_completionDate = nil }
        
        let resolvedCompleted = uncompletedTask.change(status: ScheduleFlatSection.complete)
        let resolvedUncompleted = completedTask.change(status: ScheduleFlatSection.uncomplete)
        let resolvedUnchangedCompleted = completedTask.change(status: ScheduleFlatSection.complete)

        expect(resolvedCompleted.isComplete) == true
        expect(resolvedUncompleted.isComplete) == false
        expect(resolvedUnchangedCompleted.isComplete) == true
    }
    
    func testShouldConsiderRepeatWhenChangeToFlatStatus() {
        let taskWithRepeat = factory.make {
            $0.repeatPreferences = createRepeat(.daily)
            $0.test_datePreference = createDatePref(absoluteDate, isAllDay: false)
            $0.test_reminder = createReminder(absoluteDate, offset: 0)
        }
        let taskWithoutRepeat = factory.make {
            $0.repeatPreferences = createRepeat(.none)
            $0.test_datePreference = createDatePref(absoluteDate, isAllDay: false)
        }
        
        let resolvedWithRepeat = taskWithRepeat.change(status: ScheduleFlatSection.complete)
        let resolvedWithoutRepeat = taskWithoutRepeat.change(status: ScheduleFlatSection.complete)
        
        expect(resolvedWithRepeat.datePreference.date) == absoluteDate.tomorrow
        expect(resolvedWithoutRepeat.datePreference) == taskWithoutRepeat.datePreference
        expect(resolvedWithRepeat.reminder.trigger.absoluteDate) == absoluteDate.tomorrow
        expect(resolvedWithoutRepeat.reminder) == taskWithoutRepeat.reminder
        
        expect(resolvedWithRepeat.completionDate).to(beNil())
        expect(resolvedWithoutRepeat.completionDate?.timeless) == Date.now.timeless
    }
}

class TaskFormatterReminderChangeTestCase: TaskFormatterTestCaseBase {
    
    func testChangeRemindTrigger() {
        var morningTask = factory.make {
            $0.test_datePreference = .init(assumedDate: Date.now.morning, isAllDay: false)
        }
        let newTrigger = createTrigger(offset: 1)
        
        morningTask.modify(remind: newTrigger)
        
        expectRemindValues(morningTask, id: morningTask.reminder.id, absoluteDate: morningTask.datePreference.date, relativeOffset: 1)
    }
    
    func testChangeRemindTriggerWhenTaskAllDay() {
        var todayAllDayTask = factory.make {
            $0.test_datePreference = .init(assumedDate: Date.now, isAllDay: true)
        }
        let newTrigger = createTrigger(offset: 1)
        
        todayAllDayTask.modify(remind: newTrigger)
        
        expectRemindValues(todayAllDayTask, id: todayAllDayTask.reminder.id, absoluteDate: todayAllDayTask.datePreference.date, relativeOffset: 1)
    }
    
    func testShouldChangeRemindTriggerAfterChangeDatePreferences() {
        let reminder = createReminder(offset: 0)
        let task = factory.make {
            $0.test_reminder = reminder
        }
        let newDatePreferences = createDatePref(Date.now.tomorrow, isAllDay: false)
        var resolvedTask = task
        
        resolvedTask.modify(datePreferences: newDatePreferences)
        
        expectRemindValues(resolvedTask, id: task.reminder.id, absoluteDate: newDatePreferences.date, relativeOffset: 0)
    }
    
    func testShouldNotChangeRemindTriggerAfterChangeDatePreferencesIfTriggerIsNil() {
        let reminder = createReminder(nil, offset: 0)
        let task = factory.make {
            $0.test_reminder = reminder
        }
        let newDatePreferences = createDatePref(Date.now.tomorrow, isAllDay: false)
        var resolvedTask = task
        
        resolvedTask.modify(datePreferences: newDatePreferences)
        
        expectRemindValues(resolvedTask, id: task.reminder.id, absoluteDate: nil, relativeOffset: 0)
    }

    func testShouldResolveEmptyTriggerAfterChangeDatePreferencesWithNilDate() {
        let reminder = createReminder(offset: 0)
        let task = factory.make {
            $0.test_reminder = reminder
        }
        let newDatePreferences = createDatePref(nil)
        var resolvedTask = task
        
        resolvedTask.modify(datePreferences: newDatePreferences)
        
        expectRemindValues(resolvedTask, id: task.reminder.id, absoluteDate: nil, relativeOffset: 0)
    }
    
    // If a task has an all day preference set to true,
    // therefore an absolute date is equal to a start of day,
    // therefore an offset relative to the start of day.
    // After change of the all day preference, relative offset needs to be recalculated
    // Example:
    // before change:   isAllDay = true,   absoluteDate = 25.09.18 00:00, relativeOffset = 300
    // changes:         isAllDay = false,  absoluteDate = 25.09.18 01:00
    // expected change: isAllDay = false,  absoluteDate = 25.09.18 01:00, relativeOffset = 3300 (1 hour - 5 minutes = 55 minutes)
    func testShouldChangeRemindTriggerAfterChangeAllDayToFalse() {
        let absoluteDate = Date.now.startOfDay
        let reminder = createReminder(offset: 1)
        let task = factory.make {
            $0.test_reminder = reminder
            $0.test_datePreference = createDatePref(absoluteDate, isAllDay: true)
        }
        
        let expectedDate = Date.now
        let expectedOffset = difference(expectedDate, absoluteDate) - reminder.relativeOffset
        let newDatePref = createDatePref(expectedDate, isAllDay: false)
        var resolvedTask = task
        
        resolvedTask.modify(datePreferences: newDatePref)
        
        expectRemindValues(resolvedTask, id: task.reminder.id, absoluteDate: expectedDate, relativeOffset: expectedOffset)
    }
    
    // If a task has an all day preference set to false,
    // therefore an absolute date maybe is not equal to a start of day,
    // therefore an offset maybe is not relative to the start of day.
    // After change of the all day preference, relative offset needs to be recalculated
    // Example:
    // before change:   isAllDay = false,  absoluteDate = 25.09.18 01:00, relativeOffset = 3300
    // changes:         isAllDay = true,   absoluteDate = 25.09.18 00:00
    // expected change: isAllDay = true,   absoluteDate = 25.09.18 00:00, relativeOffset = 300 (1 hour - 55 minutes = 5 minutes)
    func testShouldChangeRemindTriggerAfterChangeAllDayToTrue() {
        let reminder = createReminder(offset: 1)
        let task = factory.make {
            $0.test_reminder = reminder
            $0.test_datePreference = createDatePref(absoluteDate, isAllDay: false)
        }
        
        let newDatePref = createDatePref(absoluteDate, isAllDay: true)
        let expectedDate = absoluteDate.startOfDay
        let expectedOffset = difference(absoluteDate, expectedDate) - reminder.relativeOffset
        var resolvedTask = task
        
        resolvedTask.modify(datePreferences: newDatePref)
        
        expectRemindValues(resolvedTask, id: task.reminder.id, absoluteDate: expectedDate, relativeOffset: expectedOffset)
    }
    
    // Validation occurs only when task has an all day preference set to true
    func testValidateNegativeRelativeOffset() {
        var todayAllDayTask = factory.make {
            $0.test_datePreference = .init(assumedDate: Date.now, isAllDay: true)
        }
        let trigger = createTrigger(offset: -1)
        
        todayAllDayTask.modify(remind: trigger)
        
        expect(todayAllDayTask.reminder.trigger.absoluteDate) == todayAllDayTask.datePreference.date
        expect(todayAllDayTask.reminder.trigger.relativeOffset) == 0
    }
    
    // Validation occurs only when task has an all day preference set to true
    func testValidateRelativeOffsetIfBiggerThanSecondsInDay() {
        var todayAllDayTask = factory.make {
            $0.test_datePreference = .init(assumedDate: Date.now, isAllDay: true)
        }
        let trigger = createTrigger(offset: 86401)
        
        todayAllDayTask.modify(remind: trigger)
        
        expect(todayAllDayTask.reminder.trigger.absoluteDate) == todayAllDayTask.datePreference.date
        expect(todayAllDayTask.reminder.trigger.relativeOffset) == 86400
    }
}
