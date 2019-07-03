//
//  CalendarDateProvider.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct PageDirection: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let top    = PageDirection(rawValue: 1 << 0)
    public static let bottom = PageDirection(rawValue: 1 << 1)
}

public extension Calendar {
    func generateNextLoadInterval(_ position: PageDirection, _ viewModel: CalendarListViewModel, loadLimit: Int) -> DateInterval? {
        return nil
//        var loadDate: Date?
//
//        switch position {
//        case .top:
//            loadDate = viewModel.sections.first?.date.value.yesterday
//
//        case .bottom:
//            loadDate = viewModel.sections.last?.date.value.tomorrow
//
//        default:
//            loadDate = viewModel.sections.last?.date.value.tomorrow
//        }
//
//        guard let nextLoadDate = loadDate else { return nil }
//        return generateDateInterval(from: nextLoadDate, to: position, loadLimit: loadLimit)
    }
    
//    public func generateDateInterval(startDate: TimelessDate, limit: Int, position: Set<PageDirection>) -> DateInterval {
//        var interval = DateInterval()
//
//        for pos in position {
//            let posInterval = generateDateInterval(from: startDate.value, to: pos, loadLimit: limit)
//            interval = interval + posInterval
//        }
//        return interval
//    }
    
    func generateSortedDateArray(from date: Date, at position: PageDirection, loadLimit: Int) -> [TimelessDate] {
        var top: [TimelessDate] {
            return taskem_generateDateArray(from: date.startOfDay, daysToGenerate: loadLimit, direction: .backward).uniqueElements.sorted().map { TimelessDate($0) }
        }
        var bottom: [TimelessDate] {
            return taskem_generateDateArray(from: date.startOfDay, daysToGenerate: loadLimit, direction: .forward).uniqueElements.sorted().map { TimelessDate($0) }
        }
        
        switch position {
        case .top:
            return top
        case .bottom:
            return bottom
        default:
            return (top + bottom).uniqueElements.sorted()
        }
    }
    
    func generateDateInterval(from date: Date, to position: PageDirection, loadLimit: Int) -> DateInterval {
        switch position {
        case .top:
            return .init(start: taskem_dateFromDays(date.startOfDay, days: -loadLimit), end: date.startOfDay)
        case .bottom:
            return .init(start: date.startOfDay, end: taskem_dateFromDays(date.startOfDay, days: loadLimit))
        case [.top, .bottom]:
            return .init(start: taskem_dateFromDays(date.startOfDay, days: -loadLimit), end: taskem_dateFromDays(date.startOfDay, days: loadLimit))
        default:
            fatalError()
        }
    }
    
    func generateDateInterval(from dates: Date, borders: Int) -> DateInterval {
        return DateInterval(
            start: taskem_dateFromDays(dates, days: -borders),
            end: taskem_dateFromDays(dates, days: borders)
        )
    }
    
    func generateDateInterval(from dates: [TimelessDate]) -> DateInterval? {
        guard let start = dates.min()?.value,
            let end = dates.max()?.value else { return nil }
        return .init(start: start, end: end)
    }
}

fileprivate extension DateInterval {
    static func + (lhs: DateInterval, rhs: DateInterval) -> DateInterval {
        let min = lhs.start < rhs.start ? lhs.start : rhs.start
        let max = lhs.end > rhs.end ? lhs.end : rhs.end
        return .init(start: min, end: max)
    }
}
