//
//  TaskPopupRouter.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol TaskPopupRouter {
    func dismiss()
    
    func presentCalendarPopup(_ initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
    func presentGroupPopup(_ initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback)
    func presentRepeatPicker(_ initialData: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback)
    
    func presentReminderTemplates(_ initialDate: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback)
    func presentReminderManual(_ initialDate: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback)
}
