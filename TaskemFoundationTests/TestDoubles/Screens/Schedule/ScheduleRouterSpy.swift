//
//  ScheduleRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/19/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleRouterSpy: ScheduleRouter {
    var invokedPresentPopMenu = false
    var invokedPresentPopMenuCount = 0
    func presentPopMenu() {
        invokedPresentPopMenu = true
        invokedPresentPopMenuCount += 1
    }
    var invokedPresentScheduleControl = false
    var invokedPresentScheduleControlCount = 0
    func presentScheduleControl() {
        invokedPresentScheduleControl = true
        invokedPresentScheduleControlCount += 1
    }
    var invokedPresentTaskPopup = false
    var invokedPresentTaskPopupCount = 0
    var invokedPresentTaskPopupParameters: (initialData: TaskPopupPresenter.InitialData, Void)?
    var invokedPresentTaskPopupParametersList = [(initialData: TaskPopupPresenter.InitialData, Void)]()
    func presentTaskPopup(initialData: TaskPopupPresenter.InitialData) {
        invokedPresentTaskPopup = true
        invokedPresentTaskPopupCount += 1
        invokedPresentTaskPopupParameters = (initialData, ())
        invokedPresentTaskPopupParametersList.append((initialData, ()))
    }
    var invokedPresentDatePickerPopup = false
    var invokedPresentDatePickerPopupCount = 0
    var invokedPresentDatePickerPopupParameters: (initialData: DatePickerTemplatesPresenter.InitialData, Void)?
    var invokedPresentDatePickerPopupParametersList = [(initialData: DatePickerTemplatesPresenter.InitialData, Void)]()
    var stubbedPresentDatePickerPopupCompletionResult: (DatePreferences?, Void)?
    func presentDatePickerPopup(initialData: DatePickerTemplatesPresenter.InitialData, completion: @escaping DatePickerCallback) {
        invokedPresentDatePickerPopup = true
        invokedPresentDatePickerPopupCount += 1
        invokedPresentDatePickerPopupParameters = (initialData, ())
        invokedPresentDatePickerPopupParametersList.append((initialData, ()))
        if let result = stubbedPresentDatePickerPopupCompletionResult {
            completion(result.0)
        }
    }
    var invokedPresentGroupPopup = false
    var invokedPresentGroupPopupCount = 0
    var invokedPresentGroupPopupParameters: (initialData: GroupPopupPresenter.InitialData, Void)?
    var invokedPresentGroupPopupParametersList = [(initialData: GroupPopupPresenter.InitialData, Void)]()
    var stubbedPresentGroupPopupCompletionResult: (Group?, Void)?
    func presentGroupPopup(initialData: GroupPopupPresenter.InitialData, completion: @escaping GroupPopupCallback) {
        invokedPresentGroupPopup = true
        invokedPresentGroupPopupCount += 1
        invokedPresentGroupPopupParameters = (initialData, ())
        invokedPresentGroupPopupParametersList.append((initialData, ()))
        if let result = stubbedPresentGroupPopupCompletionResult {
            completion(result.0)
        }
    }
    var invokedPresentTask = false
    var invokedPresentTaskCount = 0
    var invokedPresentTaskParameters: (initialData: TaskOverviewPresenter.InitialData, frame: CGRect?)?
    var invokedPresentTaskParametersList = [(initialData: TaskOverviewPresenter.InitialData, frame: CGRect?)]()
    func presentTask(initialData: TaskOverviewPresenter.InitialData, frame: CGRect?) {
        invokedPresentTask = true
        invokedPresentTaskCount += 1
        invokedPresentTaskParameters = (initialData, frame)
        invokedPresentTaskParametersList.append((initialData, frame))
    }
    var invokedPresentReschedule = false
    var invokedPresentRescheduleCount = 0
    func presentReschedule() {
        invokedPresentReschedule = true
        invokedPresentRescheduleCount += 1
    }
    var invokedPresentComplete = false
    var invokedPresentCompleteCount = 0
    func presentComplete() {
        invokedPresentComplete = true
        invokedPresentCompleteCount += 1
    }
    var invokedPresentSearch = false
    var invokedPresentSearchCount = 0
    func presentSearch() {
        invokedPresentSearch = true
        invokedPresentSearchCount += 1
    }
    var invokedAlertDelete = false
    var invokedAlertDeleteCount = 0
    var invokedAlertDeleteParameters: (title: String, message: String)?
    var invokedAlertDeleteParametersList = [(title: String, message: String)]()
    var stubbedAlertDeleteCompletionResult: (Bool, Void)?
    func alertDelete(title: String, message: String, _ completion: @escaping (Bool) -> Void) {
        invokedAlertDelete = true
        invokedAlertDeleteCount += 1
        invokedAlertDeleteParameters = (title, message)
        invokedAlertDeleteParametersList.append((title, message))
        if let result = stubbedAlertDeleteCompletionResult {
            completion(result.0)
        }
    }
    var invokedAlertView = false
    var invokedAlertViewCount = 0
    var invokedAlertViewParameters: (message: String, Void)?
    var invokedAlertViewParametersList = [(message: String, Void)]()
    func alertView(message: String) {
        invokedAlertView = true
        invokedAlertViewCount += 1
        invokedAlertViewParameters = (message, ())
        invokedAlertViewParametersList.append((message, ()))
    }
}
