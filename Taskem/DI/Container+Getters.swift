//
//  Container+Getters.swift
//  Taskem
//
//  Created by Wilson on 21.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

extension Container {

    static func get(data: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback) -> GroupPopupViewController {
        return get(data, completion)
    }

    static func get(data: TaskPopupPresenter.InitialData) -> TaskPopupViewController {
        return get(data)
    }

    static func get(data: TaskOverviewPresenter.InitialData) -> TaskOverviewViewController {
        return get(data)
    }
    
    static func get(data: EventOverviewPresenter.InitialData) -> EventOverviewViewController {
        return get(data)
    }
    
    static func get(data: TaskNotesPresenter.InitialData, callback: @escaping TaskNotesCallback) -> TaskNotesViewController {
        return get(data, callback)
    }
    
    static func get(data: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback) -> RepeatTemplatesViewController {
        return get(data, callback)
    }

    static func get(data: RepeatManualPresenter.InitialData, callback: @escaping TaskRepeatCallback) -> RepeatManualViewController {
        return get(data, callback)
    }

    static func get(data: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback) -> ReminderTemplatesViewController {
        return get(data, callback)
    }

    static func get(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) -> ReminderManualViewController {
        return get(data, callback)
    }

    static func get(data: DatePickerTemplatesPresenter.InitialData, callback: @escaping DatePickerCallback) -> DatePickerTemplatesViewController {
        return get(data, callback)
    }

    static func get(data: DatePickerManualPresenter.InitialData, callback: @escaping DatePickerCallback) -> DatePickerManualViewController {
        return get(data, callback)
    }

    static func get(data: GroupOverviewPresenter.InitialData) -> GroupOverviewViewController {
        return get(data)
    }

    static func get(data: GroupColorPickerPresenter.InitialData, callback: @escaping GroupColorPickerCallback) -> GroupColorPickerViewController {
        return get(data, callback)
    }

    static func get(data: GroupIconPickerPresenter.InitialData, callback: @escaping GroupIconPickerCallback) -> GroupIconPickerViewController {
        return get(data, callback)
    }
    
    static func get(delegate: CalendarPageDelegate) -> CalendarViewController {
        return get(delegate)
    }
    
    static func get(email: String) -> PasswordResetViewController {
        return get(email)
    }
}
