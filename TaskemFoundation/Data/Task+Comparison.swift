//
//  Task+Comparison.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension Task {
    static func creationDateSortDescriptor() -> SortDescriptor<Task> {
        return { lhs, rhs in
            let creationComparison = lhs.creationDate.compare(rhs.creationDate)
            guard creationComparison == .orderedSame else {
                return creationComparison == .orderedDescending
            }
            return nil
        }
    }

    static func completionDateSortDescriptor() -> SortDescriptor<Task> {
        return { lhs, rhs in
            if lhs.completionDate != nil, rhs.completionDate == nil {
                return false
            } else if lhs.completionDate == nil, rhs.completionDate != nil {
                return true
            } else if lhs.completionDate == nil, rhs.completionDate == nil {
                return nil
            }
    
            let dateComparison = lhs.completionDate!.compare(rhs.completionDate!)
            guard dateComparison == .orderedSame else {
                return dateComparison == .orderedDescending
            }
            return nil
        }
    }

    static func nameSortDescriptor() -> SortDescriptor<Task> {
        return sortDescriptor(key: { $0.name }, String.caseInsensitiveCompare)
    }

    static func assumedDateSortDescriptor() -> SortDescriptor<Task> {
        return { lhs, rhs in
            let lhsDatePreference = lhs.datePreference
            let rhsDatePreference = rhs.datePreference
            let comparator = DefaultСomparator()
            
            return comparator.compareDatesWithAllDayPriority(lhsDatePreference.date,
                                                             lAllDay: lhsDatePreference.isAllDay,
                                                             rhsDatePreference.date,
                                                             rAllDay: rhsDatePreference.isAllDay)
        }
    }

    static func completionSortDescriptor() -> SortDescriptor<Task> {
        return { lhs, rhs in
            guard let lhsDate = lhs.completionDate, let rhsDate = rhs.completionDate else {
                if lhs.completionDate != nil, rhs.completionDate == nil {
                    return false
                } else if lhs.completionDate == nil, rhs.completionDate != nil {
                    return true
                }
                return nil
            }

            let dateComparison = lhsDate.compare(rhsDate)
            guard dateComparison == .orderedSame else {
                return dateComparison == .orderedDescending
            }

            return nil
        }
    }   
}

extension Task {
    public static func compare(lhs: Task, rhs: Task, by preference: ScheduleTableSort) -> Bool {
        switch preference {
        case .name:
            return Task.compareByName(lhs: lhs, rhs: rhs)
        case .date:
            return Task.compareByDate(lhs: lhs, rhs: rhs)
        }
    }

    static func compareByCompletion(lhs: Task, rhs: Task) -> Bool {
        let sortDescriptors = [Task.completionSortDescriptor(), Task.nameSortDescriptor(), Task.assumedDateSortDescriptor()]
        return combine(sortDescriptors: sortDescriptors)(lhs, rhs) ?? false
    }

    static func compareByCreation(lhs: Task, rhs: Task) -> Bool {
        let sortDescriptors = [Task.creationDateSortDescriptor(), Task.nameSortDescriptor(), Task.assumedDateSortDescriptor()]
        return combine(sortDescriptors: sortDescriptors)(lhs, rhs) ?? false
    }

    static func compareByName(lhs: Task, rhs: Task) -> Bool {
        let sortDescriptors = [Task.nameSortDescriptor(), Task.assumedDateSortDescriptor(), Task.completionSortDescriptor()]
        return combine(sortDescriptors: sortDescriptors)(lhs, rhs) ?? false
    }

    static func compareByDate(lhs: Task, rhs: Task) -> Bool {
        let sortDescriptors = [Task.completionSortDescriptor(), Task.assumedDateSortDescriptor(), Task.nameSortDescriptor()]
        return combine(sortDescriptors: sortDescriptors)(lhs, rhs) ?? false
    }
}
