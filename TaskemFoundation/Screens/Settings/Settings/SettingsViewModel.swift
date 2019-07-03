//
//  SettingsViewModel.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum SettingsViewModel: Identifiable, Equatable {
    case simple(SettingsSimpleViewModel)
    case time(SettingsTimeViewModel)
    
    public var id: EntityId {
        switch self {
        case .simple(let model):
            return model.id
        case .time(let model):
            return model.id
        }
    }
    
    public var item: SettingsSimpleViewModel.Item {
        switch self {
        case .simple(let model):
            return model.item
        case .time(let model):
            return model.item
        }
    }
}

public struct SettingsSimpleViewModel: Identifiable, Equatable {
    public var item: Item
    public var title: String
    public var description: String?
    public var accessory: Accessory
    public var icon: Icon
    
    public init(item: Item,
                title: String,
                accessory: Accessory,
                description: String?,
                icon: Icon) {
        self.title = title
        self.description = description
        self.item = item
        self.accessory = accessory
        self.icon = icon
    }
    
    public var id: EntityId {
        return item.rawValue
    }
}

public extension SettingsSimpleViewModel {
    enum Accessory: Int {
        case none
        case present
        case checked
    }
    
    enum Item: String {
        case profile
        
        case theme
        case reminderSound
        case firstWeekday
        
        case morning
        case noon
        case evening
        
        case deaultList
        case completed
        case reschedule
        
        case share
        case rateUs
        case leaveFeedback
        case help
        case privacyPolicy
        case termsOfUse
    }
}

public struct SettingsTimeViewModel: Identifiable, Equatable {
    public var title: String
    public var description: String?
    
    public var item: SettingsSimpleViewModel.Item
    public var time: DayTime
    public var minTime: DayTime
    public var maxTime: DayTime
    public var extended: Bool
    public var icon: Icon
    
    public init(item: SettingsSimpleViewModel.Item,
                time: DayTime,
                min: DayTime,
                max: DayTime,
                title: String,
                description: String?,
                extended: Bool,
                icon: Icon) {
        self.title = title
        self.time = time
        self.minTime = min
        self.maxTime = max
        self.description = description
        self.item = item
        self.extended = extended
        self.icon = icon
    }

    public var id: EntityId {
        return item.rawValue
    }
}

public class SettingsSectionViewModel: Section {
    public typealias T = SettingsViewModel
    
    public var cells: [SettingsViewModel]
    public var title: String
    
    public init() {
        self.cells = []
        self.title = ""
    }
    
    public init(cells: [SettingsViewModel], title: String) {
        self.cells = cells
        self.title = title
    }
}

public class SettingsListViewModel: List {
    public typealias T = SettingsViewModel
    public typealias U = SettingsSectionViewModel
    
    public var sections: [SettingsSectionViewModel]
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [SettingsSectionViewModel]) {
        self.sections = sections
    }
    
    public func timeCells() -> [SettingsTimeViewModel] {
        return allCells.reduce(into: []) { result, cell in
            guard case .time(let model) = cell else { return }
            result.append(model)
        }
    }
    
    public func simpleCells() -> [SettingsSimpleViewModel] {
        return allCells.reduce(into: []) { result, cell in
            guard case .simple(let model) = cell else { return }
            result.append(model)
        }
    }
}
