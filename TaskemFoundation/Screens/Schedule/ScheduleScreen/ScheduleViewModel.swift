//
//  ScheduleViewModel.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public enum ScheduleFlatSection: Int, Comparable, CustomStringConvertible, Equatable, CaseIterable {
    case uncomplete = 0
    case complete

    public var description: String {
        switch self {
        case .uncomplete:
            return "uncompleted"
        case .complete:
            return "completed"
        }
    }

    public static let count: Int = {
        return ScheduleFlatSection.allCases.count
    }()

    static func strToStatus(strStatus: String) -> ScheduleFlatSection? {
        var status: ScheduleFlatSection?
        switch strStatus.lowercased() {
        case "uncompleted":
            status = .uncomplete
        case "completed":
            status = .complete
        default:
            break
        }
        return status
    }

    public static func < (lhs: ScheduleFlatSection, rhs: ScheduleFlatSection) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public enum ScheduleSection: Int, Comparable, CustomStringConvertible, Equatable, CaseIterable {
    case overdue = 0, today, tomorrow, upcoming, unplanned, complete

    public var description: String {
        switch self {
        case .unplanned:
            return "unplanned".uppercased()
        case .overdue:
            return "overdue".uppercased()
        case .today:
            return "today".uppercased()
        case .tomorrow:
            return "tomorrow".uppercased()
        case .upcoming:
            return "upcoming".uppercased()
        case .complete:
            return "completed".uppercased()
        }
    }

    public func statusToDate() -> Date? {
        return ScheduleSection.statusToDate(status: self)
    }
    
    public static let count: Int = {
        return ScheduleSection.allCases.count
    }()

    static func strToStatus(strStatus: String) -> ScheduleSection? {
        var status: ScheduleSection?
        switch strStatus.lowercased() {
        case "unplanned":
            status = .unplanned
        case "overdue":
            status = .overdue
        case "today":
            status = .today
        case "tomorrow":
            status = .tomorrow
        case "upcoming":
            status = .upcoming
        case "completed":
            status = .complete
        default:
            break
        }
        return status
    }

    static func statusToDate(status: ScheduleSection) -> Date? {
        let calendar = Calendar.current
        let dateProvider = DateProvider.current

        switch status {
        case .unplanned, .overdue, .complete:
            return nil
        case .today:
            return calendar.taskem_dateFromDays(dateProvider.now, days: 0)
        case .tomorrow:
            return calendar.taskem_dateFromDays(dateProvider.now, days: 1)
        case .upcoming:
            return calendar.taskem_dateFromDays(dateProvider.now, days: 2)
        }
    }

    static func dateToStatus(date: Date?) -> ScheduleSection {
        if let relativeDate = date {
            let calendar = Calendar.current
            let dateProvider = DateProvider.current

            if calendar.taskem_isDayBefore(date: relativeDate, to: dateProvider.now) {
                return .overdue
            } else if calendar.taskem_isDayInTomorrow(date: relativeDate) {
                return .tomorrow
            } else if calendar.taskem_isDayInToday(date: relativeDate) {
                return .today
            } else if calendar.taskem_isDayAfter(date: relativeDate, to: dateProvider.now.tomorrow) {
                return .upcoming
            }
        }
        return .unplanned
    }

    public static func < (lhs: ScheduleSection, rhs: ScheduleSection) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public static func > (lhs: ScheduleSection, rhs: ScheduleSection) -> Bool {
        return !(lhs < rhs)
    }
}

public enum ScheduleSectionType: Equatable {
    case schedule(ScheduleSection)
    case project(EntityId)
    case flat(ScheduleFlatSection)

    public func unwrapSchedule() -> ScheduleSection? {
        switch self {
        case .schedule(let value):
            return value
        default:
            return nil
        }
    }

    public func unwrapProject() -> EntityId? {
        switch self {
        case .project(let value):
            return value
        default:
            return nil
        }
    }

    public func unwrapFlat() -> ScheduleFlatSection? {
        switch self {
        case .flat(let value):
            return value
        default:
            return nil
        }
    }
}

public enum ScheduleSectionAction: Int, Equatable {
    case reschedule = 0
    case add
    case delete
    
    public var icon: String {
        switch self {
        case .reschedule:
            return Images.Foundation.icScheduleReschedule.name
        case .add:
            return Images.Foundation.icScheduleAddTask.name
        case .delete:
            return Images.Foundation.icScheduleClearCompleted.name
        }
    }

    static func action(for status: ScheduleSectionType) -> ScheduleSectionAction {
        switch status {
        case .schedule(let schedule):
            return .action(for: schedule)

        case .project(let project):
            return .action(for: project)

        case .flat(let flat):
            return .action(for: flat)
        }
    }

    static func action(for scheduleStatus: ScheduleSection) -> ScheduleSectionAction {
        switch scheduleStatus {
        case .overdue:
            return .reschedule
        case .complete:
            return .delete
        default:
            return .add
        }
    }

    static func action(for project: EntityId) -> ScheduleSectionAction {
        return .add
    }

    static func action(for flatStatus: ScheduleFlatSection) -> ScheduleSectionAction {
        return flatStatus == .complete ? .delete : .add
    }
}

public enum ScheduleCellViewModel: Identifiable, Equatable {
    case task(TaskModel)
    case time(CalendarTimeCell)
    
    public var id: EntityId {
        switch self {
        case .task(let task):
            return task.id
        case .time(let time):
            return time.id
        }
    }
    
    public var date: Date? {
        switch self {
        case .task(let task):
            return task.estimateDate
        case .time(let time):
            return time.date
        }
    }
    
    public var isAllDay: Bool {
        switch self {
        case .task(let task):
            return task.isAllDay
        case .time:
            return false
        }
    }
    
    public var isTask: Bool {
        switch self {
        case .task:
            return true
        case .time:
            return false
        }
    }
    
    public var name: String {
        switch self {
        case .task(let model):
            return model.name
        case .time(let model):
            return model.time
        }
    }
    
    public var isTime: Bool {
        switch self {
        case .task:
            return false
        case .time:
            return true
        }
    }
    
    public var canMove: Bool {
        switch self {
        case .task:
            return true
        case .time:
            return false
        }
    }
    
    public var canSelect: Bool {
        switch self {
        case .task:
            return true
        case .time:
            return false
        }
    }
    
    public func unwrapTask() -> TaskModel? {
        switch self {
        case .task(let value):
            return value
        default:
            return nil
        }
    }
    
    public func unwrapTime() -> CalendarTimeCell? {
        switch self {
        case .time(let value):
            return value
        default:
            return nil
        }
    }
}

public class ScheduleSectionViewModel: Section {
    public typealias T = ScheduleCellViewModel
    
    public var cells: [ScheduleCellViewModel]
    
    public var title: String
    public var isExpanded: Bool = true
    public let actionType: ScheduleSectionAction
    public var type: ScheduleSectionType

    public var headerCellsCount: Int {
        if cells.first(where: { $0.isTime }) != nil {
            return cells.count - 1
        }
        return cells.count
    }
    
    public init(cells: [ScheduleCellViewModel],
                title: String,
                type: ScheduleSectionType,
                actionType: ScheduleSectionAction) {
        self.cells = cells
        self.title = title.uppercased()
        self.type = type
        self.actionType = actionType
    }
}

public struct ScheduleNavbarCell: Equatable {
    public var id: EntityId
    public var icon: Icon
    public var color: Color
    public var name: String
    
    public init(group: Group) {
        self.id = group.id
        self.icon = group.icon
        self.color = group.color
        self.name = group.name
    }
}

open class ScheduleListViewModel: List {
    public typealias T = ScheduleCellViewModel
    public typealias U = ScheduleSectionViewModel
    
    open var sections: [ScheduleSectionViewModel] {
        didSet {
            onChangeSectionCount?()
        }
    }
    
    // sourcery: skipEquality
    open var onChangeSectionCount: (() -> Void)?
    
    open var title: String
    open var type: ScheduleTableType
    open var navbarData: [ScheduleNavbarCell]
    
    public init() {
        self.sections = []
        self.title = ""
        self.type = .schedule
        self.navbarData = []
    }

    public init(sections: [ScheduleSectionViewModel],
                title: String,
                navbarData: [ScheduleNavbarCell],
                type: ScheduleTableType) {
        self.sections = sections
        self.title = title
        self.type = type
        self.navbarData = navbarData
    }
    
    public var allTasksModel: [TaskModel] {
        return allCells.compactMap { $0.unwrapTask() }
    }
    
    public var allCompletedTasks: [Task] {
        return find(where: { $0.isComplete })
    }
    
    public func find(where predicate: (Task) -> Bool) -> [Task] {
        return allCells.compactMap { $0.unwrapTask()?.task }.filter(predicate)
    }
    
    public func unwrap(at indexes: [IndexPath]) -> [Task] {
        return indexes.map { self[$0] }.map { $0.unwrapTask()?.task }.compactMap { $0 }
    }
    
    public func indexes(where predicate: (ScheduleCellViewModel) -> Bool) -> [IndexPath] {
        return sections.enumerated().reduce(into: []) { result, section in
            
            for cell in section.element.cells.enumerated() where predicate(cell.element) {
                result.append(.init(row: cell.offset, section: section.offset))
            }
        }
    }
    
    internal func toogleSections(expanded: Bool) {
        sections.forEach {
            $0.isExpanded = expanded
        }
    }
    
    internal func toogleSections(resolvedBy config: SchedulePreferencesProtocol) {
        sections.forEach {
            switch $0.type {
            case .schedule(let value):
                $0.isExpanded = !config.scheduleUnexpanded.contains(value)
            case .project(let value):
                $0.isExpanded = !config.projectsUnexpanded.contains(value)
            case .flat(let value):
                $0.isExpanded = !config.flatUnexpanded.contains(value)
            }
        }
    }
    
    internal func indexOfSection(for date: Date) -> Int? {
        switch type {
        case .schedule:
            let status = ScheduleSection.dateToStatus(date: date)
            return sections.firstIndex(where: { $0.type.unwrapSchedule() == status })
        case .project:
            return nil
        case .flat:
            let status = ScheduleFlatSection.uncomplete
            return sections.firstIndex(where: { $0.type.unwrapFlat() == status })
        }
    }
}
