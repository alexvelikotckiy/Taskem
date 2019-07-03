//
//  FirstWeekday.swift
//  TaskemFoundation
//
//  Created by Wilson on 9/1/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum FirstWeekday: String, Equatable {
    case sunday, monday
}

extension FirstWeekday: CustomStringConvertible {
    public var description: String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        }
    }
}
