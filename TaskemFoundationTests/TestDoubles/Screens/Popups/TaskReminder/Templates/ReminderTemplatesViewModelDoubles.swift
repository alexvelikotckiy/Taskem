//
//  ReminderTemplatesViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderTemplatesViewModelMock: ReminderTemplatesListViewModel {
    var mock: ReminderTemplatesViewModelMock {
        return .init(reminder: reminder, sections: sections)
    }
}

class ReminderTemplatesViewModelStub: ReminderTemplatesViewModelMock {
    override var sections: [ReminderTemplatesSectionViewModel] {
        get {
            return [
                .init(cells: [
                    .init(title: "None", icon: "", model: .fiveMinutesBefore),
                    .init(title: "Custom", icon: "", model: .customUsingDayTime),
                    ]
                )
            ]
        }
        set {
            
        }
    }
    
    override var reminder: Reminder {
        get {
            return .init(id: .auto(), trigger: .init())
        }
        set {
            
        }
    }
}
