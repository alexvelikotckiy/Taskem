//
//  TaskSourceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class TaskSourceDummy: TaskSource {
    var observers: ObserverCollection<TaskSourceObserver> = .init()
    var allTasks: [Task] = []
    var state: DataState = .notLoaded
    
    func start() {
        
    }
    
    func stop() {
        
    }
    
    func restart() {
        
    }
    
    func add(tasks: [Task]) {
        
    }
    
    func update(tasks: [Task]) {
        
    }
    
    func remove(byIds: [EntityId]) {
        
    }
}

private var factoryTasks: TaskFactory = .init()

class TaskSourceStub: TaskSourceDummy {
    static var overduePrevWeek = factoryTasks.make {
        $0.test_datePreference.date = Date.now.previousWeek
        $0.idGroup = id_group_1
    }
    static var overdueYesterday = factoryTasks.make {
        $0.test_datePreference.date = Date.now.yesterday
        $0.idGroup = id_group_1
    }
    static var overdueYesterdayAllday = factoryTasks.make {
        $0.test_datePreference.date = Date.now.yesterday
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    
    static var todayDayStart = factoryTasks.make {
        $0.test_datePreference.date = Date.now.startOfDay
        $0.idGroup = id_group_1
    }
    static var todayAfterNow = factoryTasks.make {
        $0.test_datePreference.date = Date.now.addingTimeInterval(100)
        $0.idGroup = id_group_1
    }
    static var todayAllday = factoryTasks.make {
        $0.test_datePreference.date = Date.now
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    
    static var tomorrowDayStart = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow.startOfDay
        $0.idGroup = id_group_1
    }
    static var tomorrowAterNow = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow.addingTimeInterval(100)
        $0.idGroup = id_group_1
    }
    static var tomorrowAllday = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    
    static var upcomingDayStart = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow.tomorrow.startOfDay
        $0.idGroup = id_group_1
    }
    static var upcomingAterNow = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow.tomorrow.addingTimeInterval(100)
        $0.idGroup = id_group_1
    }
    static var upcomingAllDay = factoryTasks.make {
        $0.test_datePreference.date = Date.now.tomorrow.tomorrow.startOfDay
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    
    static var unplannedOne = factoryTasks.make {
        $0.test_datePreference.date = nil
        $0.idGroup = id_group_1
    }
    static var unplannedAllDay = factoryTasks.make {
        $0.test_datePreference.date = nil
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    
    static var completedPrevMonth = factoryTasks.make {
        $0.test_completionDate = Date.now.previousMonth
        $0.idGroup = id_group_1
    }
    static var completedAllDay = factoryTasks.make {
        $0.test_completionDate = Date.now
        $0.test_datePreference.isAllDay = true
        $0.idGroup = id_group_1
    }
    static var completedAfterNow = factoryTasks.make {
        $0.test_completionDate = Date.now.addingTimeInterval(100)
        $0.idGroup = id_group_1
    }
    
    static var projectOne = factoryTasks.make {
        $0.idGroup = id_group_1
        $0.test_datePreference.date = nil
    }
    static var projectTwo = factoryTasks.make {
        $0.idGroup = id_group_2
        $0.test_datePreference.date = nil
    }
}

class TaskSourceMock: TaskSourceStub {
    override init() {
        super.init()
    }
    
    init(_ tasks: [Task]) {
        super.init()
        self.allTasks = tasks
    }
}

class TaskSourceSpy: TaskSourceMock {
    var addedTasks: [Task] = []
    var updatedTasks: [Task] = []
    var removedTasks: [EntityId] = []
    
    var wasStartCalled = false
    var wasRestartCalled = false
    
    override func add(tasks: [Task]) {
        super.add(tasks: tasks)
        
        addedTasks.append(contentsOf: tasks)
    }
    
    override func update(tasks: [Task]) {
        super.update(tasks: tasks)
        
        updatedTasks.append(contentsOf: tasks)
    }
    
    override func remove(byIds: [EntityId]) {
        super.remove(byIds: byIds)
        
        removedTasks.append(contentsOf: byIds)
    }
    
    override func start() {
        super.start()
        
        wasStartCalled = true
    }
    
    override func restart() {
        super.restart()
        
        wasRestartCalled = true
    }
    
    var lastAddedTask: Task? {
        return addedTasks.last
    }
    
    var lastUpdatedTask: Task? {
        return updatedTasks.last
    }
    
    var lastRemovedTask: EntityId? {
        return removedTasks.last
    }
}
