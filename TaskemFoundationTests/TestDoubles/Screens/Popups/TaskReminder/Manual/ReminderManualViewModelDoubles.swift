//
//  ReminderManualViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ReminderManualViewModelMock: ReminderManualListViewModel {
    var mock: ReminderManualViewModelMock {
        return .init(sections: sections, reminder: reminder)
    }
}

class ReminderManualViewModelStub: ReminderManualViewModelMock {
    override var sections: [ReminderManualSectionViewModel] {
        get {
            return [
                .init(cells: [
                    .description(.init(date: reminder.trigger.absoluteDate!)),
                    .timePicker(.init(date: reminder.trigger.absoluteDate!))
                    ]
                )
            ]
        }
        set {
            
        }
    }
    override var reminder: Reminder {
        get {
            return .init(id: .auto(), trigger: .init(absoluteDate: DateProvider.current.now, relativeOffset: 0))
        }
        set {
            
        }
    }
}
