//
//  ScheduleConfigProvider.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension SchedulePresenter {
    public func filterPredicate(sectionType: ScheduleSectionType? = nil) -> (ScheduleCellViewModel) -> Bool {
        return { [weak self] cell in
            guard let stongSelf = self else { return false }
            switch cell {
            case .task(let task):
                return stongSelf.filter(task, by: sectionType)

            case .time(let time):
                return stongSelf.filter(time, by: sectionType)
            }
        }
    }

    public var sortPredicate: (ScheduleCellViewModel, ScheduleCellViewModel) -> Bool {
        let sortPreference = configuration.sortPreference

        return { lhs, rhs in
            switch (lhs, rhs) {
            case let (.task(a), .task(b)):
                return Task.compare(lhs: a.task, rhs: b.task, by: sortPreference)

            default:
                if let dateComparison = DefaultСomparator().compareDatesWithAllDayPriority(lhs.date,
                                                                                  lAllDay: lhs.isAllDay,
                                                                                  rhs.date,
                                                                                  rAllDay: rhs.isAllDay) {
                    return dateComparison
                }
                return true
            }
        }
    }
    
    private func filter(_ time: CalendarTimeCell, by sectionType: ScheduleSectionType?) -> Bool {
        guard let type = sectionType else {
            return true
        }

        switch type {
        case let .schedule(status):
            return status == .today

        case .project:
            return false

        case let .flat(status):
            return status == .uncomplete
        }
    }

    private func filter(_ task: TaskModel, by type: ScheduleSectionType?) -> Bool {
        guard let type = type else {
            return isSelectedProject(task.idGroup)
        }

        switch type {
        case let .schedule(status):
            return isSelectedProject(task.idGroup) && task.status == status && isSearched(task.name)

        case let .project(id):
            return isSelectedProject(task.idGroup) && task.idGroup == id && isSearched(task.name)

        case let .flat(flatStatus):
            return isSelectedProject(task.idGroup) && task.flatStatus == flatStatus && isSearched(task.name)
        }
    }

    private func isSearched(_ text: String) -> Bool {
        switch state {
        case .searching(let searchText):
            if searchText.isEmpty || searchText == "" {
                return true
            } else {
                return text.contains(searchText)
            }
        default:
            return true
        }
    }
    
    private func isSelectedProject(_ id: EntityId) -> Bool {
        switch configuration.selectedProjects.isEmpty {
        case true:
            return true
        case false:
            return configuration.selectedProjects.contains(id)
        }
    }
    
    private var configuration: SchedulePreferencesProtocol {
        return SchedulePreferences.current
    }
}
