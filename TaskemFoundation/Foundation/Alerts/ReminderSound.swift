//
//  ReminderSound.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct ReminderSound {
    public let name: String
    public let fileName: String

    public init(name: String, fileName: String) {
        self.name = name
        self.fileName = fileName
    }
}

extension ReminderSound: Equatable {
    public static func == (lhs: ReminderSound, rhs: ReminderSound) -> Bool {
        return lhs.name == rhs.name
    }
}
