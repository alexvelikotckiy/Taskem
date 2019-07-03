//
//  RepeatRule.swift
//  TaskemFoundation
//
//  Created by Wilson on 2/23/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

public enum RepeatRule: Int, CustomStringConvertible, Codable {
    case none
    case daily
    case weekly
    case monthly
    case yearly
    
    public var description: String {
        switch self {
        case .none:
            return "none"
        case .daily:
            return "daily"
        case .weekly:
            return "weekly"
        case .monthly:
            return "monthly"
        case .yearly:
            return "yearly"
        }
    }
    
    public var standardTrackDaysOfWeek: Set<Int> {
        switch self {
        case .none, .monthly, .yearly:
            return .init()
            
        case .weekly, .daily:
            return Calendar.current.allDaysOfWeek // TODO
        }
    }
}
