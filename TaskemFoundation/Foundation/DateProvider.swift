//
//  DateProvider.swift
//  TaskemFoundation
//
//  Created by Wilson on 10/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DateProviderProtocol {
    var now: Date { get }
    var time: DayTime { get }
}

public extension DateProviderProtocol {
    var time: DayTime {
        return .init(date: now)
    }
}

public struct DateProvider {
    public static var current: DateProviderProtocol = SystemDateProvider()
    
    public static func resetCurrent() {
        current = SystemDateProvider()
    }
}

internal struct SystemDateProvider: DateProviderProtocol {
    var now: Date {
        return Date()
    }
}

public extension Date {
    static var now: Date {
        return DateProvider.current.now
    }
}

//public class DevDateProvider: DateProviderProtocol {
//    public init(mode: Mode) {
//        self.mode = mode
//    }
//
//    public var now: Date {
//        switch mode {
//        case .systemTime:
//            return Date()
//        case .fixed(let value):
//            return value
//        }
//    }
//
//    public var mode: Mode
//}
//
//public extension DevDateProvider {
//    public enum Mode {
//        case systemTime
//        case fixed(Date)
//    }
//}
