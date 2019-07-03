//
//  TimelessDate.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct TimelessDate {
    private var _date: Date
    
    public init(_ date: Date) {
        _date = date.startOfDay
    }
    
    public init?(_ date: Date?) {
        guard let date = date else { return nil }
        self._date = date.startOfDay
    }
    
    public init() {
        _date = DateProvider.current.now.startOfDay
    }
    
    public var value: Date {
        get {
            return _date
        }
        set {
            _date = newValue.startOfDay
        }
    }
}

extension TimelessDate: Equatable, Hashable {
    public static func == (lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.value == rhs.value
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_date.timeIntervalSince1970)
    }
}

extension TimelessDate: Comparable {
    public static func < (lhs: TimelessDate, rhs: TimelessDate) -> Bool {
        return lhs.value < rhs.value
    }
}

public extension Date {
    var timeless: TimelessDate {
        return .init(self)
    }
}
