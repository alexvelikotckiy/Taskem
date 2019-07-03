//
//  ReminderManualViewModel.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum ReminderManualViewModel: Identifiable, Equatable {
    case description(ReminderManualDescriptionViewModel)
    case timePicker(ReminderManualTimePickerViewModel)
    
    public var isDescription: Bool {
        switch self {
        case .description:
            return true
        default:
            return false
        }
    }
    
    public var id: EntityId {
        switch self {
        case .description:
            return "id_description"
        case .timePicker:
            return "id_time_picker"
        }
    }
}

public struct ReminderManualDescriptionViewModel: Equatable {
    public var date: Date
    
    public init(date: Date) {
        self.date = date
    }
    
    public var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

public struct ReminderManualTimePickerViewModel: Equatable {
    public var date: Date
    
    public init(date: Date) {
        self.date = date
    }
}

public class ReminderManualSectionViewModel: Section, AutoEquatable {
    public typealias T = ReminderManualViewModel
    
    public var cells: [ReminderManualViewModel]
    
    public init(cells: [T]) {
        self.cells = cells
    }
}

open class ReminderManualListViewModel: List, AutoEquatable {
    public typealias T = ReminderManualViewModel
    public typealias U = ReminderManualSectionViewModel
    
    open var sections: [ReminderManualSectionViewModel]
    open var reminder: Reminder

    public init() {
        self.sections = []
        self.reminder = Reminder()
    }

    public init(sections: [U], reminder: Reminder) {
        self.sections = sections
        self.reminder = reminder
    }
}
