//
//  ReminderTemplatesViewModel.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct ReminderTemplatesViewModel: Identifiable, Equatable {
    public var icon: Icon
    public var title: String
    public var model: ReminderRule

    public init(title: String,
         icon: Icon,
         model: ReminderRule) {
        self.title = title
        self.icon = icon
        self.model = model
    }
    
    public var id: EntityId {
        return "\(model.rawValue)"
    }
}

public class ReminderTemplatesSectionViewModel: Section, AutoEquatable {
    public typealias T = ReminderTemplatesViewModel
    
    public var cells: [ReminderTemplatesViewModel] = []
    
    public init(cells: [T]) {
        self.cells = cells
    }
}

open class ReminderTemplatesListViewModel: List, AutoEquatable {
    public typealias T = ReminderTemplatesViewModel
    public typealias U = ReminderTemplatesSectionViewModel
    
    open var reminder: Reminder
    open var sections: [ReminderTemplatesSectionViewModel]

    public init() {
        self.sections = []
        self.reminder = .init()
    }

    public init(reminder: Reminder, sections: [ReminderTemplatesSectionViewModel]) {
        self.sections = sections
        self.reminder = reminder
    }
}
