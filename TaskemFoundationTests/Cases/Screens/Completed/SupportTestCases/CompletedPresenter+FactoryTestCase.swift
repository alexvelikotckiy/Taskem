//
//  CompletedPresenter+FactoryTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class CompletedViewModelFactoryTestCase: CompletedPresenterTestCaseBase {
    
    private var taskYesterday: TaskModel!
    private var taskToday: TaskModel!
    private var taskTomorrow: TaskModel!
    private var taskUncompleted: TaskModel!
    
    override func setUp() {
        super.setUp()
        
        taskYesterday = produceTaskModel(factoryTasks.make { task in
            task.test_completionDate = dateProvider.now.yesterday.addingTimeInterval(-1)
        })
        taskToday = produceTaskModel(factoryTasks.make { task in
            task.test_completionDate = dateProvider.now
        })
        taskTomorrow = produceTaskModel(factoryTasks.make { task in
            task.test_completionDate = dateProvider.now.tomorrow
        })
        taskUncompleted = produceTaskModel(factoryTasks.make { task in
            task.test_completionDate = nil
        })
    }
    
    var models: [TaskModel] {
        return [taskToday, taskYesterday, taskTomorrow, taskUncompleted]
    }
    
    func testShouldProduceSections() {
        let sections: [CompletedSectionViewModel] = presenter.produce(from: .sections(models))!
        
        expectValidSections(sections)
    }
    
    func testShouldProduceList() {
        let list: CompletedListViewModel = presenter.produce(from: .list(models))!
        
        expectValidSections(list.sections)
    }
    
    private func expectValidSections(_ sections: [CompletedSectionViewModel], line: UInt = #line) {
        expect(sections[0].cells.count, line: line) == 2
        expect(sections[0].cells[0].model, line: line) == taskTomorrow
        expect(sections[0].cells[1].model, line: line) == taskToday
        expect(sections[1].cells.count, line: line) == 1
        expect(sections[1].cells[0].model, line: line) == taskYesterday
    }
}
