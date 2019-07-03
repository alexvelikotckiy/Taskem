//
//  CalendarPresenter+Filter.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension CalendarPresenter {
    
    public func filterPredicate(at date: TimelessDate? = nil) -> (CalendarCellConvertible) -> Bool {
        return { [weak self] cell in
            guard let strongSelf = self else { return false }
            let filter: (CalendarCellViewModel) -> Bool = strongSelf.filterPredicate(at: date)
            return filter(cell.convertToCalendar)
        }
    }
    
    public func filterPredicate(at date: TimelessDate? = nil) -> (CalendarCellViewModel) -> Bool {
        return { [weak self] cell in
            guard let stongSelf = self else { return false }
            switch cell {
                
            case .task(let value):
                return stongSelf.applyFilterToTask(value) && (date == nil ? true : value.datePreference.date?.timeless == date)

            case .event(let value):
                return stongSelf.applyFilterToEvent(value) && (date == nil ? true : value.occurrenceDate.timeless == date)

            case .time(let value):
                return date == nil ? true : (value.date.timeless == date)

            case .freeday(let value):
                return stongSelf.configuration.style == .bydate && (date == nil ? true : value.date == date)
            }
        }
    }
    
    public var sortPredicate: (CalendarCellViewModel, CalendarCellViewModel) -> Bool {
        let comparator = DefaultСomparator()
        
        return { lhs, rhs in
            if let dateComparison = comparator.compareDatesWithAllDayPriority(lhs.date,
                                                                              lAllDay: lhs.isAllDay,
                                                                              rhs.date,
                                                                              rAllDay: rhs.isAllDay) {
                return dateComparison
            }
            switch (lhs, rhs) {
            case let (.task(a), .task(b)):
                return Task.compare(lhs: a.task, rhs: b.task, by: .name)
    
            case let (.event(a), .event(b)):
                return a.name < b.name
    
            default:
                return lhs.id > rhs.id
            }
        }
    }
    
    private func applyFilterToTask(_ task: TaskModel) -> Bool {
        if applySelectedProjects(task.idGroup) {
            switch true {
            case task.datePreference.date == nil:
                return false
            case !task.isComplete:
                return true
            case configuration.showCompleted where task.isComplete:
                return true
            default:
                return false
            }
        }
        return false
    }

    private func applyFilterToEvent(_ event: EventModel) -> Bool {
        if applySelectedCalendars(event.idCalednar) {
            return true
        }
        return false
    }

    private func applySelectedProjects(_ id: EntityId) -> Bool {
        if configuration.unselectedTaskemGroups.isEmpty {
            return true
        } else {
            return !configuration.unselectedTaskemGroups.contains(id)
        }
    }

    private func applySelectedCalendars(_ id: EntityId) -> Bool {
        if configuration.unselectedAppleCalendars.isEmpty {
            return true
        } else {
            return !configuration.unselectedAppleCalendars.contains(id)
        }
    }
    
    private var configuration: CalendarConfiguration {
        return CalendarPreferences.current
    }
}
