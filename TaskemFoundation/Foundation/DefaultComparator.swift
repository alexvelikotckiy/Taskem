//
//  DefaultСomparator.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/27/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DefaultСomparator {
    public init() {
        
    }
    
    public func compareDatesWithAllDayPriority(_ lDate: Date?, lAllDay: Bool, _ rDate: Date?, rAllDay: Bool) -> Bool? {
        if let allDayComparison = compareAllDay(lAllDay, rAllDay) {
            return allDayComparison
        }
        return compareDates(lDate, rDate)
    }
    
    public func compareDates(_ lDate: Date?, _ rDate: Date?) -> Bool? {
        return compareDatesDescriptor(lDate, rDate)
    }
    
    public func compareAllDay(_ lAllDay: Bool, _ rAllDay: Bool) -> Bool? {
        return compareAllDayDescriptor(lAllDay, rAllDay)
    }
    
    private var compareAllDayDescriptor: SortDescriptor<Bool> {
        return { lhs, rhs in
            if lhs, !rhs {
                return false
            } else if !lhs, rhs {
                return true
            }
            return nil
        }
    }
    
    private var compareDatesDescriptor: SortDescriptor<Date?> {
        return { lhs, rhs in
            if lhs != nil, rhs == nil {
                return false
            } else if lhs == nil, rhs != nil {
                return true
            } else if lhs == nil, rhs == nil {
                return nil
            }
            
            return lhs!.compare(rhs!) == .orderedAscending
        }
    }
}
