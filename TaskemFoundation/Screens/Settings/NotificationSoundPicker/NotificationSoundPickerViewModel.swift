//
//  NotificationSoundPickerViewModel.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct NotificationSoundPickerViewModel: Identifiable, Equatable {
    public let sound: ReminderSound
    public var selected: Bool
    
    public init(sound: ReminderSound, selected: Bool) {
        self.sound = sound
        self.selected = selected
    }
    
    public var id: EntityId {
        return sound.name
    }
}

public class NotificationSoundPickerSectionViewModel: Section {
    public typealias T = NotificationSoundPickerViewModel
    
    public var cells: [NotificationSoundPickerViewModel]
    
    public init(cells: [NotificationSoundPickerViewModel]) {
        self.cells = cells
    }
}

public class NotificationSoundPickerListViewModel: List {
    public typealias T = NotificationSoundPickerViewModel
    public typealias U = NotificationSoundPickerSectionViewModel
    
    public var sections: [NotificationSoundPickerSectionViewModel]
    
    public init() {
        self.sections = []
    }
    
    public init(sections: [NotificationSoundPickerSectionViewModel]) {
        self.sections = sections
    }
}
