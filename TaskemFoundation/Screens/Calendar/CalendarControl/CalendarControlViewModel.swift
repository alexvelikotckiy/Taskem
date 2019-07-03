//
//  CalendarControlViewModel.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum CalendarControlViewModel: Identifiable, Equatable {
    case group(CalendarControlGroupModel)
    case calendar(CalendarControlIOSCalendarModel)
    
    public var id: EntityId {
        switch self {
        case .group(let model):
            return model.group.id
        case .calendar(let model):
            return model.calendar.id
        }
    }
    
    public var title: String {
        switch self {
        case .group(let model):
            return model.group.name
        case .calendar(let model):
            return model.calendar.title
        }
    }
    
    public var isSelected: Bool {
        get {
            switch self {
            case .group(let model):
                return model.isSelected
            case .calendar(let model):
                return model.isSelected
            }
        }
        set {
            switch self {
            case .group(var model):
                model.isSelected = newValue
                self = .group(model)
            case .calendar(var model):
                model.isSelected = newValue
                self = .calendar(model)
            }
        }
    }
    
    public var canSelect: Bool {
        switch self {
        case .group:
            return true
        case .calendar:
            return true
        }
    }
}

public struct CalendarControlGroupModel: Equatable {
    public var group: Group
    public var isSelected: Bool
    
    public init(group: Group,
                isSelected: Bool) {
        self.group = group
        self.isSelected = isSelected
    }
}

public struct CalendarControlIOSCalendarModel: Equatable {
    public var calendar: EventKitCalendar
    public var isSelected: Bool
    
    public init(calendar: EventKitCalendar,
                isSelected: Bool) {
        self.calendar = calendar
        self.isSelected = isSelected
    }
}

public class CalendarControlSectionViewModel: Section {
    public typealias T = CalendarControlViewModel
    
    public var cells: [CalendarControlViewModel]
    
    public var title: String
    
    public init() {
        self.cells = []
        self.title = ""
    }
    
    public init(title: String,
                cells: [CalendarControlViewModel]) {
        self.title = title
        self.cells = cells
    }
}

public class CalendarControlListViewModel: List {
    public typealias T = CalendarControlViewModel
    public typealias U = CalendarControlSectionViewModel
    
    public var sections: [CalendarControlSectionViewModel]
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [CalendarControlSectionViewModel]) {
        self.sections = sections
    }
    
    public var isAllSelected: Bool {
        for cell in allCells {
            if !cell.isSelected, cell.canSelect {
                return false
            }
        }
        return true
    }
}
