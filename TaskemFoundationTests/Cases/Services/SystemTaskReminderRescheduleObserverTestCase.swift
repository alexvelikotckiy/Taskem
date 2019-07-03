//
//  SystemTaskReminderRescheduleObserverTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SystemTaskReminderRescheduleObserverTestCase: TaskemTestCaseBase {

    private var decorator: SystemTaskReminderRescheduleObserver!
    private var maganerSpy: RemindScheduleManagerSpy!
    
    private let factory: TaskFactory = .init()
    
    private var taskWithReminder: Task!
    private var taskWithoutReminder: Task!
    private var taskWithReminderCompleted: Task!
    
    private let soundName = "test_sound"
    
    override func setUp() {
        super.setUp()
        
        maganerSpy = .init()
        decorator = .init(scheduler: maganerSpy)
        decorator.identityProvider = NotificationIdentityProviderStub()
        
        taskWithReminder = produceTaskWithReminder()
        taskWithoutReminder = produceTaskWithoutReminder()
        taskWithReminderCompleted = produceTaskCompletedWithReminder()
        
        userPreferences.reminderSound = soundName
    }

    private func produceTaskWithReminder() -> Task {
        return factory.make {
            $0.test_reminder = .init(id: .auto(), trigger: .init(absoluteDate: Date.now, relativeOffset: 0))
        }
    }
    
    private func produceTaskWithoutReminder() -> Task {
        return factory.make {
            $0.test_reminder = .init(id: .auto(), trigger: .init(absoluteDate: nil, relativeOffset: 0))
        }
    }
    
    private func produceTaskCompletedWithReminder() -> Task {
        return factory.make {
            $0.test_reminder = .init(id: .auto(), trigger: .init(absoluteDate: Date.now, relativeOffset: 0))
            $0.test_completionDate = Date.now
        }
    }
    
    func testShouldBeTaskSourceObserver() {
        expect(self.decorator).to(beAKindOf(TaskSourceObserver.self))
    }
    
    func testShouldRescheduleWhenLoaded() {
        let source = TaskSourceDummy()
        source.allTasks = [taskWithReminder, taskWithReminder]
        source.state = .loaded
        
        decorator.sourceDidChangeState(source)
        
        expectNumberOfUnschedules(2)
        expectNumberOfSchedules(2)
    }
    
    func testShouldDoNothingWhenLoading() {
        let source = TaskSourceDummy()
        source.allTasks = [taskWithReminder, taskWithoutReminder, taskWithReminderCompleted]
        source.state = .loading
        
        decorator.sourceDidChangeState(source)
        
        expectNumberOfSchedules(0)
        expectNumberOfUnschedules(0)
    }
    
    func testShouldDoNothingWhenNotLoaded() {
        let source = TaskSourceDummy()
        source.allTasks = [taskWithReminder, taskWithoutReminder, taskWithReminderCompleted]
        source.state = .notLoaded
        
        decorator.sourceDidChangeState(source)
        
        expectNumberOfSchedules(0)
        expectNumberOfUnschedules(0)
    }
    
    func testShouldScheduleWhenAddTaskWithReminderOn() {
        let taskOne = produceTaskWithReminder()
        let taskTwo = produceTaskWithReminder()
        
        decorator.source(TaskSourceDummy(), didAdd: [taskOne, taskTwo])
        
        expectReschedule(tasks: [taskOne, taskTwo])
    }
    
    func testShouldNotScheduleWhenAddTaskWithReminderOffOrCompleted() {
        let taskOne = taskWithoutReminder!
        let taskTwo = taskWithReminderCompleted!
        
        decorator.source(TaskSourceDummy(), didAdd: [taskOne, taskTwo])
        
        expectUnscheduledIds([taskOne, taskTwo].map { $0.id })
        expectNumberOfSchedules(0)
    }
    
    func testShouldRescheduleWhenUpdateTaskWithReminderOn() {
        let taskOne = produceTaskWithReminder()
        let taskTwo = produceTaskWithReminder()
        
        decorator.source(TaskSourceDummy(), didUpdate: [taskOne, taskTwo])
        
        expectReschedule(tasks: [taskOne, taskTwo])
    }
    
    func testShouldUnscheduleWhenUpdateTaskWithReminderOffOrCompleted() {
        let taskOne = taskWithoutReminder!
        let taskTwo = taskWithReminderCompleted!
        
        decorator.source(TaskSourceDummy(), didUpdate: [taskOne, taskTwo])
        
        expectUnscheduledIds([taskOne, taskTwo].map { $0.id })
        expectNumberOfSchedules(0)
    }
    
    func testShouldUnscheduleWhenRemoveTask() {
        let taskIdOne: EntityId = .auto()
        let taskIdTwo: EntityId = .auto()
        
        decorator.source(TaskSourceDummy(), didRemove: [taskIdOne, taskIdTwo])
        
        expect(self.maganerSpy.unscheduleCalls.count) == 2
        expect(self.maganerSpy.unscheduleCalls[0].entityId) == taskIdOne
        expect(self.maganerSpy.unscheduleCalls[1].entityId) == taskIdTwo
    }
    
    private func expectReschedule(tasks: [Task], line: UInt = #line) {
        expectUnscheduledIds(tasks.map { $0.id })
        
        for task in tasks {
            let schedule = createSchedule(from: task)
            expectSchedule(schedule, line: line)
        }
    }
    
    private func createSchedule(from task: Task) -> RemindSchedule {
        return .init(
            id: createNotificationId(from: task),
            title: task.name,
            body: task.notes,
            date: task.reminder.remindDate!,
            sound: soundName,
            categoryId: "task"
        )
    }
    
    private func createNotificationId(from task: Task) -> String {
        return decorator.identityProvider.produceNotificationId(
            category: .task,
            entityId: task.id,
            reminderId: task.reminder.id,
            date: task.reminder.remindDate!
        )
    }
    
    private func expectSchedule(_ schedule: RemindSchedule, line: UInt = #line) {
        expect(self.maganerSpy.scheduleCalls, line: line).to(contain(schedule))
    }
    
    private func expectUnscheduledIds(_ ids: [EntityId], line: UInt = #line) {
        let unscheduledIds = maganerSpy.unscheduleCalls.map { $0.entityId }
        expect(unscheduledIds, line: line).to(contain(ids))
    }
    
    private func expectNumberOfSchedules(_ count: Int, line: UInt = #line) {
        expect(self.maganerSpy.scheduleCalls.count, line: line) == count
    }
    
    private func expectNumberOfUnschedules(_ count: Int, line: UInt = #line) {
        expect(self.maganerSpy.unscheduleCalls.count, line: line) == count
    }
    
    private func createDatePref(_ assumedDate: Date? = nil, isAllDay: Bool = false) -> DatePreferences {
        return .init(assumedDate: assumedDate, isAllDay: isAllDay)
    }
    
    private func createReminder(_ id: EntityId = .auto(), trigger: ReminderTrigger = .init()) -> Reminder {
        return .init(id: id, trigger: trigger)
    }
}
