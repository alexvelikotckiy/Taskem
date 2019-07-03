//
//  EventKitCalendar.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation
import EventKit

public struct EventKitCalendar: Equatable, Identifiable {
    public var id: String
    public let title: String
    public let color: Color
    public let allowsContentModifications: Bool

    public init(calendar: EKCalendar) {
        self.id = calendar.calendarIdentifier
        self.title = calendar.title
        self.color = UIColor.init(cgColor: calendar.cgColor).color
        self.allowsContentModifications = calendar.allowsContentModifications
    }
    
    public init(id: String,
                title: String,
                color: CGColor,
                allowsContentModifications: Bool) {
        self.id = id
        self.title = title
        self.color = UIColor.init(cgColor: color).color
        self.allowsContentModifications = allowsContentModifications
    }
}
