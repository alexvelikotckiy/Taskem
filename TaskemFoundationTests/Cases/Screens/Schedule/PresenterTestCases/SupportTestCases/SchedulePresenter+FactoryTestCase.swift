//
//  ScheduleFactoryTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleFactoryTestCase: SchedulePresenterTestCaseBase {
    
    func testShouldProduceTimeCell() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short

        let cell: CalendarTimeCell = presenter.produce(from: .time)!

        expect({
            if dateFormatter.string(from: Date.now) != cell.time {
                return .failed(reason: "Wrong time")
            }
            return .succeeded
        }).to(succeed())
    }
    
    func testShouldProduceNavBarCells() {
        let list = GroupFactory().make { $0.id = id_group_1 }
        schedulePreferences.selectedProjects = [list.id].set
        
        let cells: [ScheduleNavbarCell] = presenter.produce(from: .navbar([list]))!
        
        expect(cells.map { $0.id }.first) == list.id
    }
}

class ScheduleFactorySectionsTestCase: SchedulePresenterTestCaseBase {
    
    private var listStub: ScheduleListViewModel!
    
    override func setUp() {
        super.setUp()

        listStub = ScheduleViewModelStub()

        schedulePreferences.typePreference = .schedule
    }

    func testShouldContainOnlyOneTimeCell() {
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .schedule, [], false))!

        expect({
            var timeCellCount = 0
            for cell in list.allCells {
                guard case .time(_) = cell else { continue }
                timeCellCount += 1
            }
            return timeCellCount == 1 ? .succeeded : .failed(reason: "Should contain only 1 time cell")
        }).to(succeed())
    }

    func testShouldFilterOnlySelectedGroups() {
        let cellStub = ScheduleCellStubs().allProjectStubs()
        schedulePreferences.selectedProjects = [id_group_1]

        let list: ScheduleListViewModel = presenter.produce(from:
            .list(cellStub.map { $0.unwrapTask()! }, .schedule, [], false))!

        expect(list.allCells.first) == cellStub[0]
        expect(list.allCells.count) == 1
    }

    func testShouldProduceValidScheduleList() {
        let projects = stubFactory.produceProjects()
        schedulePreferences.selectedProjects = projects.map { $0.id }.set
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .schedule, projects, false))!
        
        expect(list) == listStub
    }

    func testShouldNotContainEmptySections() {
        let cellStub = listStub.allCells.first!

        let list: ScheduleListViewModel = presenter.produce(from:
            .list([cellStub.unwrapTask()!], .schedule, stubFactory.produceProjects(), false))!

        expect(list.allCells) == [cellStub]
        expect(list.sections.count) == 1
    }
}

class ScheduleProjectFactorySectionsTest: SchedulePresenterTestCaseBase {
    
    private var listStub: ScheduleListViewModel!
    
    override func setUp() {
        super.setUp()

        listStub = ScheduleProjectsModelStub()

        schedulePreferences.selectedProjects = [id_group_1, id_group_2].set
        schedulePreferences.typePreference = .project
    }

    func testShouldFilterOnlySelectedGroups() {
        let cellStub = ScheduleCellStubs().allProjectStubs()
        schedulePreferences.selectedProjects = [id_group_1]
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(cellStub.map { $0.unwrapTask()! }, .project, [], false))!
        
        expect(list.allCells.contains(cellStub[0])) == true
        expect(list.allCells.contains(cellStub[1])) == false
    }

    func testShouldProduceValidProjectList() {
        let projects = stubFactory.produceProjects()
        schedulePreferences.selectedProjects = projects.map { $0.id }.set
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .project, projects, false))!
        
        expect(list) == listStub
    }

    func testShouldNotContainTimeCell() {
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .project, [], false))!

        expect({
            var timeCellCount = 0
            for cell in list.allCells {
                guard case .time(_) = cell else { continue }
                timeCellCount += 1
            }
            return timeCellCount == 0 ? .succeeded : .failed(reason: "Should not contain time cell")
        }).to(succeed())
    }
}

class ScheduleFlatFactorySectionsTestCase: SchedulePresenterTestCaseBase {
    
    private var listStub: ScheduleListViewModel!
    
    override func setUp() {
        super.setUp()

        listStub = ScheduleFlatModelStub()
        
        schedulePreferences.typePreference = .flat
    }

    func testShouldContainOnlyOneTimeCell() {
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .flat, [], false))!

        expect({
            var timeCellCount = 0
            for cell in list.allCells {
                guard case .time(_) = cell else { continue }
                timeCellCount += 1
            }
            return timeCellCount == 1 ? .succeeded : .failed(reason: "Should contain only 1 time cell")
        }).to(succeed())
    }

    func testShouldFilterOnlySelectedGroups() {
        let cellStub = ScheduleCellStubs().allProjectStubs()
        schedulePreferences.selectedProjects = [id_group_1]
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(cellStub.map { $0.unwrapTask()! }, .flat, [], false))!

        expect(list.allCells.contains(cellStub[0])) == true
        expect(list.allCells.contains(cellStub[1])) == false
    }

    func testShouldProduceValidFlatList() {
        let projects = stubFactory.produceProjects()
        schedulePreferences.selectedProjects = projects.map { $0.id }.set
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(listStub.allTasksModel, .flat, projects, false))!

        expect(list) == listStub
    }

    func testShouldNotContainEmptySections() {
        let cellStubs = ScheduleCellStubs().completed()
        
        let list: ScheduleListViewModel = presenter.produce(from:
            .list(cellStubs.map { $0.unwrapTask()! }, .flat, [], false))!

        expect(list.allCells) == cellStubs
        expect(list.sections.count) == 1
    }
}
