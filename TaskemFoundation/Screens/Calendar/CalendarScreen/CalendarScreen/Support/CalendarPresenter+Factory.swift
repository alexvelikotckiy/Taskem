//
//  CalendarPresenter+Factory.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarCellConvertible {
    var convertToCalendar: CalendarCellViewModel { get }
}

public typealias CalendarCellsConvertible = [CalendarCellConvertible]

extension CalendarCellViewModel: CalendarCellConvertible {
    public var convertToCalendar: CalendarCellViewModel {
        return self
    }
}

extension TaskModel: CalendarCellConvertible {
    public var convertToCalendar: CalendarCellViewModel {
        return .task(self)
    }
}

extension EventModel: CalendarCellConvertible {
    public var convertToCalendar: CalendarCellViewModel {
        return .event(self)
    }
}

extension CalendarTimeCell: CalendarCellConvertible {
    public var convertToCalendar: CalendarCellViewModel {
        return .time(self)
    }
}

extension CalendarFreeDayCell: CalendarCellConvertible {
    public var convertToCalendar: CalendarCellViewModel {
        return .freeday(self)
    }
}

extension CalendarPresenter: ViewModelFactory {
    public func produce<T>(from context: CalendarPresenter.Context) -> T? {
        switch context {
        case .list(let data, let interval, let style, let initialDate):
            return list(data, interval, style, initialDate) as? T
        case .sections(let data, let interval, let style):
            return sections(data, interval, style) as? T
        case .cells(let data):
            return cells(data) as? T
        case .freeday(let initialDate):
            return freeday(initialDate) as? T
        case .time:
            return time() as? T
        }
    }
    
    public enum Context {
        case list       (data: CalendarCellsConvertible, interval: DateInterval?, style: CalendarStyle, initialDate: TimelessDate)
        case sections   (data: CalendarCellsConvertible, interval: DateInterval?, style: CalendarStyle)
        case cells      (data: CalendarCellsConvertible)
        case freeday    (date: TimelessDate)
        case time
    }
}

private extension CalendarPresenter {
    func list(_ data: CalendarCellsConvertible,
              _ interval: DateInterval?,
              _ style: CalendarStyle,
              _ initialDate: TimelessDate) -> CalendarListViewModel {
        return CalendarListViewModel(
            sections: sections(data, interval, style),
            initialDate: initialDate,
            style: style
        )
    }

    func sections(_ data: CalendarCellsConvertible,
                  _ interval: DateInterval?,
                  _ style: CalendarStyle) -> [CalendarSectionViewModel] {
        let cells = self.cells(data)
        return Calendar.current.taskem_generateDateSequence(from: cells, on: interval).reduce(into: []) { result, date in
            switch style {
            case .bydate:
                let content = cells
                    .filter(filterPredicate(at: date))
                    .removeTimeIfNeed()
                    .insertTimeIfNeed(at: date, cell: time())
                    .insertFreedayIfNeed(cell: freeday(date))
                    .sorted(by: sortPredicate)
                result.append(CalendarSectionViewModel(date: date, cells: content))

            case .standard:
                let content = cells
                    .filter(filterPredicate(at: date))
                    .removeTimeIfNeed()
                    .insertTimeIfNeed(at: date, cell: time())
                    .sorted(by: sortPredicate)

                if !content.isEmpty {
                    result.append(CalendarSectionViewModel(date: date, cells: content))
                }
            }
        }
    }

    func cells(_ data: CalendarCellsConvertible) -> [CalendarCellViewModel] {
        return data.map { $0.convertToCalendar }.sorted(by: sortPredicate)
    }

    func freeday(_ date: TimelessDate) -> CalendarFreeDayCell {
        return .init(date: date)
    }

    func time() -> CalendarTimeCell {
        let now = Date.now
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter
        }()
        return .init(time: dateFormatter.string(from: now), date: now)
    }
}

fileprivate extension Array where Element == CalendarCellViewModel {
    @discardableResult
    func removeTimeIfNeed() -> [Element] {
        return self.filter { !$0.isTime }
    }
    
    @discardableResult
    func insertTimeIfNeed(at date: TimelessDate, cell: CalendarTimeCell) -> [Element] {
        var mutable = self
        if !mutable.isEmpty, Calendar.current.isDateInToday(date.value) {
            mutable.append(cell.convertToCalendar)
        }
        return mutable
    }
    
    @discardableResult
    func insertFreedayIfNeed(cell: CalendarFreeDayCell) -> [Element] {
        var mutable = self
        if mutable.isEmpty {
            mutable.append(cell.convertToCalendar)
        }
        return mutable
    }
}

fileprivate extension Calendar {
    func taskem_generateDateSequence(from cells: [CalendarCellViewModel], on interval: DateInterval?) -> [TimelessDate] {
        if let interval = interval {
            return Calendar.current.taskem_generateDays(interval).map { TimelessDate($0) }
        } else {
            let dateProvider = DateProvider.current
            var dates = cells.compactMap { $0.date?.startOfDay }
            
            if dates.first(where: { $0 < dateProvider.now }) != nil,
                dates.first(where: { $0 > dateProvider.now }) != nil {
                dates.append(dateProvider.now.startOfDay)
            }
            
            return dates.uniqueElements.sorted().map { TimelessDate($0) }
        }
    }
}
