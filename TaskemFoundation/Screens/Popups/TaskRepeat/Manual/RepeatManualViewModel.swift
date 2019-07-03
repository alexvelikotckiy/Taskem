//
//  TaskRepeatSetupViewModel.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct RepeatDaysOfWeekData: Equatable {
    public var days: [String]
    public var selected: [Int]

    public init(days: [String],
                selected: [Int]) {
        self.days = days
        self.selected = selected
    }
}

public struct RepeatModelData: Equatable {
    public var cases: [Model]
    public var selected: Model

    public enum Model: String, CaseIterable {
        case daily = "Day"
        case weekly = "Week"
        case monthly = "Month"
        case yearly = "Year"
        
        public init(rule: RepeatRule) {
            switch rule {
            case .none:
                self = .daily
            case .daily:
                self = .daily
            case .weekly:
                self = .weekly
            case .monthly:
                self = .monthly
            case .yearly:
                self = .yearly
            }
        }
        
        public init?(index: Int) {
            switch index {
            case 0:
                self = .daily
            case 1:
                self = .weekly
            case 2:
                self = .monthly
            case 3:
                self = .yearly
            default:
                return nil
            }
        }
    }
    
    public init(selected: Model) {
        self.cases = Model.allCases
        self.selected = selected
    }
    
    public init(cases: [Model],
                selected: Model) {
        self.cases = cases
        self.selected = selected
    }
}

public struct RepeatEndDateData: Equatable {
    public var dateTitle: String
    public var dateSubtitle: String?
    public var date: Date?
    public var style: Presentation
    
    public init(dateTitle: String,
                dateSubtitle: String?,
                date: Date?,
                displayType: Presentation = .simple) {
        self.dateTitle = dateTitle
        self.dateSubtitle = dateSubtitle
        self.date = date
        self.style = displayType
    }
    
    public var isOverdue: Bool {
        guard let date = date else { return false }
        return date < Date.now
    }
    
    public enum Presentation: Int {
        case simple
        case extended
        
        func toogle() -> Presentation {
            return self == .simple ? .extended : .simple
        }
    }
}

public class RepeatManualSectionViewModel: Section {
    public typealias T = RepeatManualListViewModel.Cell
    
    public var cells: [RepeatManualListViewModel.Cell]
    
    public init() {
        self.cells = []
    }
    
    public init(cells: [RepeatManualListViewModel.Cell]) {
        self.cells = cells
    }
}

open class RepeatManualListViewModel: List {
    public typealias T = Cell
    public typealias U = RepeatManualSectionViewModel
    
    open var sections: [RepeatManualSectionViewModel]
    open var `repeat`: RepeatPreferences

    public init() {
        self.sections = []
        self.repeat = .init()
    }

    public init(repeat: RepeatPreferences,
                sections: [RepeatManualSectionViewModel]) {
        self.repeat = `repeat`
        self.sections = sections
    }
    
    public enum Cell: Equatable, Identifiable {
        case repetition(RepeatModelData)
        case endDate(RepeatEndDateData)
        case daysOfWeek(RepeatDaysOfWeekData)
        
        public var id: EntityId {
            switch self {
            case .repetition(_):
                return "repetition"
            case .endDate(_):
                return "endDate"
            case .daysOfWeek(_):
                return "daysOfWeek"
            }
        }
        
        public func unwrap() -> RepeatModelData? {
            guard case let .repetition(value) = self else { return nil }
            return value
        }
        
        public func unwrap() -> RepeatEndDateData? {
            guard case let .endDate(value) = self else { return nil }
            return value
        }
        
        public func unwrap() -> RepeatDaysOfWeekData? {
            guard case let .daysOfWeek(value) = self else { return nil }
            return value
        }
        
        public var isDayOfWeek: Bool {
            switch self {
            case .daysOfWeek:
                return true
            default:
                return false
            }
        }
        
        public var isRepeatModel: Bool {
            switch self {
            case .repetition:
                return true
            default:
                return false
            }
        }
        
        public var isEndDate: Bool {
            switch self {
            case .endDate:
                return true
            default:
                return false
            }
        }
    }
    
    public func get(_ predicate: (Cell) -> Bool) -> Cell? {
        for cell in allCells where predicate(cell) {
            return cell
        }
        return nil
    }
    
    internal var indexOfWithDaysOfWeek: Int? {
        return allCells.firstIndex { item in
            if case .daysOfWeek = item {
                return true
            }
            return false
        }
    }
}
