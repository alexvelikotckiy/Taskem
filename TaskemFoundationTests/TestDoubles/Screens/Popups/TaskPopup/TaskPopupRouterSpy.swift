//
//  TaskPopupRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskPopupRouterSpy: TaskPopupRouter {
    var invokedDismiss = false
    var invokedDismissCount = 0
    func dismiss() {
        invokedDismiss = true
        invokedDismissCount += 1
    }
    var invokedPresentCalendarPopup = false
    var invokedPresentCalendarPopupCount = 0
    var invokedPresentCalendarPopupParameters: (initialData: DatePickerTemplatesPresenter.InitialData, Void)?
    var invokedPresentCalendarPopupParametersList = [(initialData: DatePickerTemplatesPresenter.InitialData, Void)]()
    var stubbedPresentCalendarPopupCompletionResult: (DatePreferences?, Void)?
    func presentCalendarPopup(_ initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        invokedPresentCalendarPopup = true
        invokedPresentCalendarPopupCount += 1
        invokedPresentCalendarPopupParameters = (initialData, ())
        invokedPresentCalendarPopupParametersList.append((initialData, ()))
        if let result = stubbedPresentCalendarPopupCompletionResult {
            completion(result.0)
        }
    }
    var invokedPresentGroupPopup = false
    var invokedPresentGroupPopupCount = 0
    var invokedPresentGroupPopupParameters: (initialData: GroupPopupPresenter.InitialData, Void)?
    var invokedPresentGroupPopupParametersList = [(initialData: GroupPopupPresenter.InitialData, Void)]()
    var stubbedPresentGroupPopupCompletionResult: (Group?, Void)?
    func presentGroupPopup(_ initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback) {
        invokedPresentGroupPopup = true
        invokedPresentGroupPopupCount += 1
        invokedPresentGroupPopupParameters = (initialData, ())
        invokedPresentGroupPopupParametersList.append((initialData, ()))
        if let result = stubbedPresentGroupPopupCompletionResult {
            completion(result.0)
        }
    }
    var invokedPresentRepeatPicker = false
    var invokedPresentRepeatPickerCount = 0
    var invokedPresentRepeatPickerParameters: (initialData: RepeatTemplatesPresenter.InitialData, Void)?
    var invokedPresentRepeatPickerParametersList = [(initialData: RepeatTemplatesPresenter.InitialData, Void)]()
    var stubbedPresentRepeatPickerCallbackResult: (RepeatPreferences?, Void)?
    func presentRepeatPicker(_ initialData: RepeatTemplatesPresenter.InitialData, callback: @escaping TaskRepeatCallback) {
        invokedPresentRepeatPicker = true
        invokedPresentRepeatPickerCount += 1
        invokedPresentRepeatPickerParameters = (initialData, ())
        invokedPresentRepeatPickerParametersList.append((initialData, ()))
        if let result = stubbedPresentRepeatPickerCallbackResult {
            callback(result.0)
        }
    }
    var invokedPresentReminderTemplates = false
    var invokedPresentReminderTemplatesCount = 0
    var invokedPresentReminderTemplatesParameters: (initialDate: ReminderTemplatesPresenter.InitialData, Void)?
    var invokedPresentReminderTemplatesParametersList = [(initialDate: ReminderTemplatesPresenter.InitialData, Void)]()
    var stubbedPresentReminderTemplatesCallbackResult: (Reminder?, Void)?
    func presentReminderTemplates(_ initialDate: ReminderTemplatesPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        invokedPresentReminderTemplates = true
        invokedPresentReminderTemplatesCount += 1
        invokedPresentReminderTemplatesParameters = (initialDate, ())
        invokedPresentReminderTemplatesParametersList.append((initialDate, ()))
        if let result = stubbedPresentReminderTemplatesCallbackResult {
            callback(result.0)
        }
    }
    var invokedPresentReminderManual = false
    var invokedPresentReminderManualCount = 0
    var invokedPresentReminderManualParameters: (initialDate: ReminderManualPresenter.InitialData, Void)?
    var invokedPresentReminderManualParametersList = [(initialDate: ReminderManualPresenter.InitialData, Void)]()
    var stubbedPresentReminderManualCallbackResult: (Reminder?, Void)?
    func presentReminderManual(_ initialDate: ReminderManualPresenter.InitialData, callback: @escaping TaskReminderCallback) {
        invokedPresentReminderManual = true
        invokedPresentReminderManualCount += 1
        invokedPresentReminderManualParameters = (initialDate, ())
        invokedPresentReminderManualParametersList.append((initialDate, ()))
        if let result = stubbedPresentReminderManualCallbackResult {
            callback(result.0)
        }
    }
}
