//
//  ScheduleViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/27/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleViewModelStubFactory {

    private let factoryTasks: TaskFactory = .init()
    private let factoryGroups: GroupFactory = .init()
    private let factoryTaskModel: TaskModelFactory = .init()

    func produceViewModelTime() -> ScheduleCellViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let absoluteDate = Date.now
        return .time(.init(time: dateFormatter.string(from: absoluteDate), date: absoluteDate))
    }

    func produceViewModel(_ task: Task) -> ScheduleCellViewModel {
        let group = factoryGroups.make {
            $0.id = task.idGroup
            $0.name = task.idGroup
        }
        let model = TaskModel(task: task, group: group)
        return .task(model)
    }
    
    func produceViewModel(status: ScheduleSection) -> ScheduleCellViewModel {
        let model = produceTaskModel(status: status)
        return .task(model)
    }
    
    func produceViewModel(status: ScheduleFlatSection) -> ScheduleCellViewModel {
        let model = produceTaskModel(status: status)
        return .task(model)
    }
    
    func produceTaskModel(status: ScheduleSection) -> TaskModel {
        let task = produceTask(status: status)
        let group = factoryGroups.make { $0.id = task.idGroup }
        return .init(task: task, group: group)
    }

    func produceTaskModel(status: ScheduleFlatSection) -> TaskModel {
        let task = produceTask(status: status)
        let group = factoryGroups.make { $0.id = task.idGroup }
        return .init(task: task, group: group)
    }

    func produceTask(status: ScheduleSection) -> Task {
        return factoryTasks.make {
            $0.test_datePreference.date = status.statusToDate()
        }
    }

    func produceTask(status: ScheduleFlatSection) -> Task {
        return factoryTasks.make {
            $0.test_completionDate = status == .complete ? Date.now : nil
        }
    }

    func produceTaskModel(_ task: Task) -> TaskModel {
        let group = factoryGroups.make { $0.id = task.idGroup }
        return .init(task: task, group: group)
    }
    
    func produceProjects() -> [Group] {
        return [
            .init(id: id_group_1, color: .defaultColor),
            .init(id: id_group_2, color: .defaultColor)
        ]
    }
    
    var sectionWithoutTime: ScheduleSectionViewModel {
        return .init(cells: [stubFactory.produceViewModel(status: .today)], title: "", type: .schedule(.today), actionType: .add)
    }
    
    var sectionWithTime: ScheduleSectionViewModel {
        let section = sectionWithoutTime
        section.cells.append(stubFactory.produceViewModelTime())
        return section
    }
    
    var sectionWithTimeOnly: ScheduleSectionViewModel {
        return .init(cells: [stubFactory.produceViewModelTime()], title: "", type: .schedule(.today), actionType: .add)
    }
}

private var stubFactory: ScheduleViewModelStubFactory = .init()

public struct ScheduleCellStubs {
    func overdue() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.overduePrevWeek),
            stubFactory.produceViewModel(TaskSourceStub.overdueYesterday),
            stubFactory.produceViewModel(TaskSourceStub.overdueYesterdayAllday)
        ]
    }

    func today() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.todayDayStart),
            stubFactory.produceViewModelTime(),
            stubFactory.produceViewModel(TaskSourceStub.todayAfterNow),
            stubFactory.produceViewModel(TaskSourceStub.todayAllday)
        ]
    }
    
    func tomorrow() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.tomorrowDayStart),
            stubFactory.produceViewModel(TaskSourceStub.tomorrowAterNow),
            stubFactory.produceViewModel(TaskSourceStub.tomorrowAllday)
        ]
    }

    func upcoming() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.upcomingDayStart),
            stubFactory.produceViewModel(TaskSourceStub.upcomingAterNow),
            stubFactory.produceViewModel(TaskSourceStub.upcomingAllDay)
        ]
    }

    func unplanned() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.unplannedOne),
            stubFactory.produceViewModel(TaskSourceStub.unplannedAllDay)
        ]
    }

    func completed() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.completedAfterNow),
            stubFactory.produceViewModel(TaskSourceStub.completedAllDay),
            stubFactory.produceViewModel(TaskSourceStub.completedPrevMonth)
        ]
    }

    func uncompleted() -> [ScheduleCellViewModel] {
        return [
            overdue(),
            today(),
            tomorrow(),
            upcoming(),
            unplanned()
        ].flatMap { $0 }
    }
    
    func allTasks() -> [TaskModel] {
        return [allScheduleStubs(), allProjectStubs()].flatMap { $0 }.compactMap { $0.unwrapTask() }
    }

    func allNavBarCellsStubs() -> [ScheduleNavbarCell] {
        return stubFactory.produceProjects().map { .init(group: $0) }
    }
    
    func allScheduleStubs() -> [ScheduleCellViewModel] {
        return [
            uncompleted(),
            completed()
        ].flatMap { $0 }
    }

    func allProjectStubs() -> [ScheduleCellViewModel] {
        return [
            stubFactory.produceViewModel(TaskSourceStub.projectOne),
            stubFactory.produceViewModel(TaskSourceStub.projectTwo)
        ]
    }

    func allFlatStubs() -> [ScheduleCellViewModel] {
        return [
            uncompleted(),
            completed()
        ].flatMap { $0 }
    }
}

private var stubs: ScheduleCellStubs = .init()

class ScheduleViewModelMock: ScheduleListViewModel {
    var mock: ScheduleListViewModel {
        return ScheduleListViewModel(sections: sections, title: title, navbarData: navbarData, type: type)
    }
}

class ScheduleViewModelStub: ScheduleViewModelMock {
    private var overdueSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.overdue(), sectionType: .overdue, actionType: .reschedule)
    }

    private var todaySection: ScheduleSectionViewModel {
        return produceStubSection(stubs.today(), sectionType: .today, actionType: .add)
    }

    private var tomorrowSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.tomorrow(), sectionType: .tomorrow, actionType: .add)
    }

    private var upcomingSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.upcoming(), sectionType: .upcoming, actionType: .add)
    }

    private var unplannedSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.unplanned(), sectionType: .unplanned, actionType: .add)
    }

    private var completedSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.completed(), sectionType: .complete, actionType: .delete)
    }

    private func produceStubSection(_ cells: [ScheduleCellViewModel],
                                    sectionType: ScheduleSection,
                                    actionType: ScheduleSectionAction) -> ScheduleSectionViewModel {
        return .init(
            cells: cells,
            title: sectionType.description,
            type: .schedule(sectionType),
            actionType: actionType
        )
    }

    override var type: ScheduleTableType {
        get {
            return .schedule
        }
        set {}
    }

    override var title: String {
        get {
            return "Schedule"
        }
        set { }
    }

    override var sections: [ScheduleSectionViewModel] {
        get {
            return [
                overdueSection,
                todaySection,
                tomorrowSection,
                upcomingSection,
                unplannedSection,
                completedSection
            ]
        }
        set { }
    }
    
    override var navbarData: [ScheduleNavbarCell] {
        get {
            return stubs.allNavBarCellsStubs()
        }
        set { }
    }
}

class ScheduleProjectsModelStub: ScheduleViewModelMock {

    private var firstSection: ScheduleSectionViewModel {
        return produceSection([stubs.allProjectStubs()[0]], sectionName: id_group_1, actionType: .add)
    }

    private var secondSection: ScheduleSectionViewModel {
        return produceSection([stubs.allProjectStubs()[1]], sectionName: id_group_2, actionType: .add)
    }

    private func produceSection(_ cells: [ScheduleCellViewModel],
                                sectionName: String,
                                actionType: ScheduleSectionAction) -> ScheduleSectionViewModel {
        return .init(
            cells: cells,
            title: sectionName,
            type: .project(sectionName),
            actionType: actionType
        )
    }

    override var type: ScheduleTableType {
        get {
            return .project
        }
        set {}
    }

    override var title: String {
        get {
            return "Schedule"
        }
        set { }
    }

    override var sections: [ScheduleSectionViewModel] {
        get {
            return [
                firstSection,
                secondSection
            ]
        }
        set { }
    }
    
    override var navbarData: [ScheduleNavbarCell] {
        get {
            return stubs.allNavBarCellsStubs()
        }
        set { }
    }
}

class ScheduleFlatModelStub: ScheduleViewModelMock {
    private var uncompletedSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.today(), sectionType: .uncomplete, actionType: .add)
    }

    private var completedSection: ScheduleSectionViewModel {
        return produceStubSection(stubs.completed(), sectionType: .complete, actionType: .delete)
    }
    
    private func produceStubSection(_ cells: [ScheduleCellViewModel],
                                    sectionType: ScheduleFlatSection,
                                    actionType: ScheduleSectionAction) -> ScheduleSectionViewModel {
        return .init(
            cells: cells,
            title: sectionType.description,
            type: .flat(sectionType),
            actionType: actionType
        )
    }

    override var type: ScheduleTableType {
        get {
            return .flat
        }
        set {}
    }

    override var title: String {
        get {
            return "Schedule"
        }
        set { }
    }

    override var sections: [ScheduleSectionViewModel] {
        get {
            return [
                uncompletedSection,
                completedSection
            ]
        }
        set { }
    }
    
    override var navbarData: [ScheduleNavbarCell] {
        get {
            return stubs.allNavBarCellsStubs()
        }
        set { }
    }
}

private extension Group {
    init(id: EntityId,
         color: Color) {
        self.init(
            id: id,
            name: id,
            isDefault: false,
            creationDate: Date.now,
            icon: Icon.defaultIcon,
            color: color
        )
    }
}
