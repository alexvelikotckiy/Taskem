//
//  CalendarViewModel.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import DifferenceKit

public struct CalendarStaticCell {
    static let time = "Time"
    static let freeday = "Freeday"
}

public enum CalendarCellViewModel: Identifiable, Equatable, Differentiable {
    public typealias DifferenceIdentifier = EntityId
    
    case task(TaskModel)
    case event(EventModel)
    case time(CalendarTimeCell)
    case freeday(CalendarFreeDayCell)

    public var differenceIdentifier: EntityId {
        return id
    }
    
    public var id: String {
        switch self {
        case .task(let task):
            return task.idTask
        case .time(let time):
            return time.id
        case .freeday(let freeday):
            return freeday.id
        case .event(let event):
            return event.id + ":" + event.displayDate.description
        }
    }

    public var date: Date? {
        switch self {
        case .task(let task):
            return task.estimateDate
        case .time(let time):
            return time.date
        case .freeday(let freeday):
            return freeday.date.value
        case .event(let event):
            return event.occurrenceDate
        }
    }

    public var isAllDay: Bool {
        switch self {
        case .task(let task):
            return task.isAllDay
        case .time:
            return false
        case .freeday:
            return true
        case .event(let event):
            return event.isAllDay
        }
    }
    
    public var isFreeday: Bool {
        switch self {
        case .freeday:
            return true
        default:
            return false
        }
    }
    
    public var isTime: Bool {
        switch self {
        case .time:
            return true
        default:
            return false
        }
    }
    
    public var isTaskOrEvent: Bool {
        switch self {
        case .task:
            return true
        case .time:
            return false
        case .freeday:
            return false
        case .event:
            return true
        }
    }
    
    public var isEvent: Bool {
        switch self {
        case .event:
            return true
        default:
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
    
    public func unwrapEvent() -> EventModel? {
        switch self {
        case .event(let value):
            return value
        default:
            return nil
        }
    }
}

extension CalendarCellViewModel: Comparable {
    public static func < (lhs: CalendarCellViewModel, rhs: CalendarCellViewModel) -> Bool {
        guard let lDate = lhs.date, let rDate = rhs.date else { return false }
        return lDate < rDate
    }
}

public struct CalendarFreeDayCell: Equatable {
    public var date: TimelessDate

    public init(date: TimelessDate) {
        self.date = date
    }
    
    public var id: EntityId {
        return CalendarStaticCell.freeday
    }
}

public struct CalendarTimeCell: Equatable {
    public let id = CalendarStaticCell.time
    public var date: Date
    public var time: String

    public init(time: String,
                date: Date) {
        self.time = time
        self.date = date
    }
}

public class CalendarSectionViewModel: Section, DifferentiableSection {
    public typealias DifferenceIdentifier = TimelessDate
    
    public typealias T = CalendarCellViewModel
    
    public var cells: [CalendarCellViewModel]
    public var date: TimelessDate
    
    public var elements: [CalendarCellViewModel] {
        return cells
    }
    
    public init(date: TimelessDate,
                cells: [CalendarCellViewModel]) {
        self.date = date
        self.cells = cells
    }
    
    public required init<C: Collection>(source: CalendarSectionViewModel,
                                        elements: C) where C.Element == CalendarCellViewModel {
        self.date = source.date
        self.cells = Array(elements)
    }
    
    public var differenceIdentifier: TimelessDate {
        return date
    }

    public func isContentEqual(to source: CalendarSectionViewModel) -> Bool {
        return date == source.date &&
            cells == source.cells
    }
}

public extension CalendarSectionViewModel {
    var title: String {
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d"
            return dateFormatter
        }()
        return dateFormatter.string(from: date.value).uppercased()
    }
    
    var subtitle: String {
        return Calendar.current.taskem_dateDifferenceToNowDescription(date: date.value)
    }
}

public class CalendarListViewModel: List {
    public typealias T = CalendarCellViewModel
    public typealias U = CalendarSectionViewModel
    
    public var sections: [CalendarSectionViewModel] {
        didSet {
            guard sections != oldValue else { return }
            onChangeSections?(sections)
        }
    }
    
    public var currentDate: TimelessDate
    public var style: CalendarStyle

    // sourcery: skipEquality
    public var onChangeSections: (([CalendarSectionViewModel]) -> Void)?
    
    public init() {
        self.currentDate = TimelessDate()
        self.style = .standard
        self.sections = []
    }
    
    public init(sections: [CalendarSectionViewModel],
                initialDate: TimelessDate,
                style: CalendarStyle) {
        self.currentDate = initialDate
        self.style = style
        self.sections = sections
    }
    
    public var canScrollTable: Bool {
        if style == .bydate,
            sections[0].cells.count == 1,
            sections[0].cells[0].isFreeday {
            return false
        }
        return true
    }
    
    public func unwrap(at indexes: [IndexPath]) -> [Task] {
        let cells = self[indexes]
        return cells.compactMap {
            guard case let .task(model) = $0 else { return nil }
            return model.task
        }
    }
}

extension Swift.Array where Element == CalendarSectionViewModel {
    public var maxDate: Date? {
        return last?.cells.last?.date
    }
    
    public var minDate: Date? {
        return first?.cells.first?.date
    }
    
    public func nearest(to date: TimelessDate) -> Int? {
        return map { $0.date.value.timeIntervalSince(date.value) }.firstIndex(where: { $0 >= 0 })
    }
    
    public func contains(date: TimelessDate) -> Bool {
        return map { $0.date }.contains(date)
    }
    
    public func index(for date: Date) -> Int? {
        return self.firstIndex(where: { Calendar.current.taskem_isSameDay(date: $0.date.value, in: date) })
    }
}

//public struct CalendarSectionsViewModel: AutoEquatable, Differentiable {
//    public typealias DifferenceIdentifier = TimelessDate
//
//    public var date: TimelessDate
//
//    public init(date: TimelessDate) {
//        self.date = date
//    }
//
//    public var differenceIdentifier: TimelessDate {
//        return date
//    }
//
//    public func isContentEqual(to source: CalendarSectionsViewModel) -> Bool {
//        return date == source.date
//    }
//}
//
//public extension CalendarSectionsViewModel {
//    public var title: String {
//        let dateFormatter: DateFormatter = {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMMM d"
//            return dateFormatter
//        }()
//        return dateFormatter.string(from: date.value).uppercased()
//    }
//
//    public var subtitle: String {
//        return Calendar.current.agenda_dateDifferenceToNowDescription(date: date.value)
//    }
//}
//
//public typealias CalendarList = [ArraySection<CalendarSectionsViewModel, CalendarCellViewModel>]
//public typealias CalendarSection = ArraySection<CalendarSectionsViewModel, CalendarCellViewModel>
//
//public struct CalendarListViewModel: AutoEquatable {
//    public var sections: [CalendarSection] {
//        didSet {
//            guard sections != oldValue else { return }
//            didChangeList?(sections)
//        }
//    }
//
//    // sourcery: skipEquality
//    public var didChangeList: ((_ newValue: [CalendarSection]) -> Void)?
//
//    public var currentDate: TimelessDate
//    public var style: CalendarStyle
//
//    public init() {
//        self.sections = []
//        self.currentDate = .init()
//        self.style = .standard
//    }
//
//    public init(sections: [CalendarSection],
//                initialDate: TimelessDate,
//                style: CalendarStyle) {
//        self.currentDate = initialDate
//        self.style = style
//        self.sections = sections
//    }
//
//    public var canScrollTable: Bool {
//        if style == .bydate,
//            sections[0].elements.count == 1,
//            sections[0].elements[0].isFreeday {
//            return false
//        }
//        return true
//    }
//}
//
//extension Swift.Array where Element == CalendarSection {
//    public subscript(index: IndexPath) -> CalendarCellViewModel {
//        get { return self[index.section].elements[index.row] }
//        set { self[index.section].elements[index.row] = newValue }
//    }
//
//    public subscript(indexes: [IndexPath]) -> [CalendarCellViewModel] {
//        return indexes.map { self[$0.section].elements[$0.row] }
//    }
//}
//
//extension Swift.Array where Element == CalendarSection {
//    public var maxDate: Date? {
//        return last?.elements.last?.date
//    }
//
//    public var minDate: Date? {
//        return first?.elements.first?.date
//    }
//
//    public func nearest(to date: TimelessDate) -> Int? {
//        return map { $0.model.date.value.timeIntervalSince(date.value) }.firstIndex(where: { $0 >= 0 })
//    }
//
//    public func contains(date: TimelessDate) -> Bool {
//        return map { $0.model.date }.contains(date)
//    }
//}
//
//extension Swift.Array where Element == CalendarSection {
//    public func unwrap(at indexes: [IndexPath]) -> [Task] {
//        let cells = self[indexes]
//        return cells.compactMap {
//            guard case let .task(model) = $0 else { return nil }
//            return model.task
//        }
//    }
//}
