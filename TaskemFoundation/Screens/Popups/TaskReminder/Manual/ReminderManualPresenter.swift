//
//  ReminderManualPresenter.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class ReminderManualPresenter: ReminderManualViewDelegate, DataInitiable {

    public weak var view: ReminderManualView?
    public var router: ReminderManualRouter
    public var interactor: ReminderManualInteractor

    private let callback: TaskReminderCallback

    public let initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var datePreferences: DatePreferences = .init()
        public var reminder: Reminder = .init()
        
        public init() {}
        
        public init(date: DatePreferences, reminder: Reminder) {
            self.datePreferences = date
            self.reminder = reminder
        }
    }
    
    public init(
        view: ReminderManualView,
        router: ReminderManualRouter,
        interactor: ReminderManualInteractor,
        data: InitialData,
        callback: @escaping TaskReminderCallback
        ) {
        self.router = router
        self.interactor = interactor
        self.view = view
        //
        self.initialData = data
        self.callback = callback
        //
        self.view?.delegate = self
        self.interactor.delegate = self
    }
    
    private var viewModel: ReminderManualListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func produceViewModel(_ reminder: Reminder) -> ReminderManualListViewModel {
        return .init(sections: produceSections(reminder), reminder: reminder)
    }
    
    private func produceSections(_ reminder: Reminder) -> [ReminderManualSectionViewModel] {
        return [
            .init(cells: [
                    .description(.init(date: reminder.trigger.absoluteDate ?? Date.now)),
                    .timePicker(.init(date: reminder.trigger.absoluteDate  ?? Date.now))
                ]
            )
        ]
    }

    public func onViewWillAppear() {
        view?.display(produceViewModel(initialData.reminder))
    }

    public func onViewWillDismiss() {
        callback(nil)
        router.dismiss()
    }
    
    public func onTouchSave() {
        interactor.registerRemindPermission()
    }
    
    public func onChangeTime(date: Date) {
        viewModel.reminder.trigger.change(absoluteDate: initialData.datePreferences.date, dayTime: date)
        viewModel[.init(row: 0, section: 0)] = .description(.init(date: date))
        view?.reload(at: .init(row: 0, section: 0))
    }
}

extension ReminderManualPresenter: ReminderManualInteractorOutput {

    public func remindermanualIteractorDidGetRemindPermission(_ interactor: ReminderManualInteractor) {
        callback(viewModel.reminder)
        router.dismiss()
    }

    public func remindermanualIteractor(_ interactor: ReminderManualInteractor, didFailGetRemindPermission error: Error?) {
        router.alert(
            title: "An error occured. Try again.",
            message: error?.localizedDescription ?? "") { [weak self] in
                self?.router.dismiss()
                self?.callback(nil)
        }
    }

    public func remindermanualIteractorDidDiniedRemindPermission(_ interactor: ReminderManualInteractor) {
        router.alert(
            title: "System access denied",
            message: "In order to use this feature allow to use notifications. You can do it in iOS Settings.") { [weak self] in
                self?.router.dismiss()
                self?.callback(nil)
        }
    }
}
