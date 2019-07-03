//
//  TaskOverviewRouter.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskOverviewRouter {
    func dismiss(expandingDismiss: Bool, completion: @escaping () -> Void)
    
    func presentTaskNotes(data: TaskNotesPresenter.InitialData, callback: @escaping TaskNotesCallback)
    func presentRepeatSetup(data: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback)
    
    func presentReminderTemplates(data: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback)
    func presentReminderManual(data: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback)
    
    func presentCalendarPopup(data: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback)
    
    func presentGroupPopup(data: GroupPopupPresenter.InitialData, completion: @escaping (Group?) -> Void)
    
    func alertDelete(title: String, message: String, _ completion: @escaping ((Bool) -> Void))
}
