//
//  TaskPopupViewModelFactoryTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import Nimble

class TaskPopupViewModelFactoryTestCase: TaskemTestCaseBase {
    
    var factory: TaskPopupDefaultViewModelFactory!
    
    override func setUp() {
        super.setUp()
        
        factory = .init()
    }
    
    func testShouldBeFactory() {
        expect(self.factory).to(beAKindOf(TaskPopupViewModelFactory.self))
    }
    
    func testProduceProjectTag() {
        let group = Group(name: id_group_1)
        
        let model = factory.produce(group)
        
        expect(model.tag.unwrap()) == group
        expectUnremovable(model)
        expect(model.color) == group.color
    }

    func testProduceDateTag() {
        let date = DatePreferences(assumedDate: Date.now.tomorrow, isAllDay: false)
        
        let model = factory.produce(date)
        
        expect(model.tag.unwrap()) == date
        expectRemovable(model)
        expectUnoverdue(model)
    }
    
    func testProduceOverdueSecondAgoDateTag() {
        let date = DatePreferences(assumedDate: Date.now.addingTimeInterval(-1), isAllDay: false)
        
        let model = factory.produce(date)
        
        expect(model.tag.unwrap()) == date
        expectRemovable(model)
        expectUnoverdue(model)
    }
    
    func testProduceOverdueYesterdayAgoDateTag() {
        let date = DatePreferences(assumedDate: Date.now.yesterday, isAllDay: false)
        
        let model = factory.produce(date)
        
        expect(model.tag.unwrap()) == date
        expectOverdue(model)
        expectRemovable(model)
    }
    
    func testProduceReminderTag() {
        let reminder = Reminder(id: .auto(), trigger: .init(absoluteDate: Date.now.tomorrow, relativeOffset: 0))
        
        let model = factory.produce(reminder)
        
        expect(model.tag.unwrap()) == reminder
        expectRemovable(model)
        expectUnoverdue(model)
    }
    
    func testProduceOverdueReminderTag() {
        let reminder = Reminder(id: .auto(), trigger: .init(absoluteDate: Date.now.yesterday, relativeOffset: 0))
        
        let model = factory.produce(reminder)
        
        expect(model.tag.unwrap()) == reminder
        expectRemovable(model)
        expectOverdue(model)
    }
    
    func testProduceRepeatTag() {
        let repetition = RepeatPreferences.init(rule: .daily)
        
        let model = factory.produce(repetition)
        
        expect(model.tag.unwrap()) == repetition
        expectRemovable(model)
        expectUnoverdue(model)
    }
    
    private func expectUnremovable(_ model: TaskPopupTagViewModel, line: UInt = #line) {
        expect(model.removable, line: line) == false
    }
    
    private func expectRemovable(_ model: TaskPopupTagViewModel, line: UInt = #line) {
        expect(model.removable, line: line) == true
    }
    
    private func expectUnoverdue(_ model: TaskPopupTagViewModel, line: UInt = #line) {
        expect(model.color, line: line) == Color(Color.TaskemMain.blue)
    }
    
    private func expectOverdue(_ model: TaskPopupTagViewModel, line: UInt = #line) {
        expect(model.color, line: line) == Color(Color.TaskemMain.yellow)
    }
}
