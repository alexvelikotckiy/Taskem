//
//  ScheduleFilterProviderTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ScheduleFilterProviderTestCase: SchedulePresenterTestCaseBase {
    
    var stubs: ScheduleCellStubs!
    
    override func setUp() {
        super.setUp()

        stubs = .init()
    }
    
    func testProduceFilterByScheduleStatus() {
        let stub = stubs.allScheduleStubs()

        let filter = presenter.filterPredicate(sectionType: .schedule(.today))

        expect(stub.filter(filter)) == stubs.today()
    }

    func testProduceFilterByProject() {
        let stub = stubs.allProjectStubs()

        let filter = presenter.filterPredicate(sectionType: .project(id_group_1))

        expect(stub.filter(filter)) == [stubs.allProjectStubs().first!]
    }

    func testProduceFilterByFlatStatus() {
        let stub = stubs.allFlatStubs()

        let filter = presenter.filterPredicate(sectionType: .flat(.complete))

        expect(stub.filter(filter)) == stubs.completed()
    }

    func testFilterOnlySelectedProjects() {
        schedulePreferences.selectedProjects = [id_group_1].set
        let stub = stubs.allProjectStubs()

        let filter = presenter.filterPredicate(sectionType: nil)
        let filtered = stub.filter(filter)

        expect(filtered.first) == stub.first
        expect(filtered.count) == 1
    }
}
