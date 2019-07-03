//
//  DayTime.swift
//  TaskemFoundation
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct DayTime: Comparable, Hashable, CustomStringConvertible, Codable {
    public let hour: Int
    public let minute: Int

    public init(date: Date) {
        self.hour = date.hour
        self.minute = date.minutes
    }

    public init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }

    internal init(minutes: Int) {
        let hoursTemp = minutes / 60
        self.hour = hoursTemp
        self.minute = minutes - hoursTemp * 60
    }
    
    public var hashValue: Int {
        return hour * 60 + minute
    }
    
    public var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let dateComponents = DateComponents(hour: hour, minute: minute)
        let date = Calendar.current.date(from: dateComponents)
        return dateFormatter.string(from: date!)
    }
    
    public enum CodingKeys: String, CodingKey {
        case hour
        case minute
    }
}

public func == (lhs: DayTime, rhs: DayTime) -> Bool {
    return dayTimeToSeconds(lhs) == dayTimeToSeconds(rhs)
}

public func < (lhs: DayTime, rhs: DayTime) -> Bool {
    return dayTimeToSeconds(lhs) < dayTimeToSeconds(rhs)
}

public func > (lhs: DayTime, rhs: DayTime) -> Bool {
    return dayTimeToSeconds(lhs) > dayTimeToSeconds(rhs)
}

private func dayTimeToSeconds(_ dayTime: DayTime) -> Int {
    return dayTimeToMinutes(dayTime) + 60
}

private func dayTimeToMinutes(_ dayTime: DayTime) -> Int {
    return dayTime.hour * 60 + dayTime.minute
}

public extension DayTime {
    func date() -> Date {
        return Calendar.current.date(from: .init(hour: hour, minute: minute))!
    }
}
