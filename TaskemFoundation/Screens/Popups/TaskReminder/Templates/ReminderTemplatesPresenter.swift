//
//  ReminderTemplatesPresenter.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class ReminderTemplatesPresenter: ReminderTemplatesViewDelegate, DataInitiable {

    public weak var view: ReminderTemplatesView?
    public var router: ReminderTemplatesRouter
    public var interactor: ReminderTemplatesInteractor

    private let callback: TaskReminderCallback
    
    private let factory: ReminderTemplatesViewModelFactory

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
        view: ReminderTemplatesView,
        router: ReminderTemplatesRouter,
        interactor: ReminderTemplatesInteractor,
        data: InitialData,
        callback: @escaping TaskReminderCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        self.callback = callback
        
        self.factory = ReminderTemplatesDefaultViewModelFactory()
        //
        self.view?.delegate = self
        self.interactor.delegate = self
    }
    
    private var viewModel: ReminderTemplatesListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    public func onViewWillAppear() {
        view?.display(factory.produceViewModel(reminder: initialData.reminder))
    }

    public func onTouchCell(at index: IndexPath) {
        let rule = viewModel[index].model
        
        switch rule {
        case .customUsingDayTime:
            router.presentManual(
                data: .init(date: initialData.datePreferences, reminder: initialData.reminder),
                callback: callback
            )
            
        default:
            resolveAndSaveTrigger(rule)
            interactor.registerRemindPermission()
        }
    }

    private func resolveAndSaveTrigger(_ rule: ReminderRule) {
        viewModel.reminder.trigger.change(absoluteDate: initialData.datePreferences.date, rule: rule)
    }
    
    public func onTouchBack() {
        callback(nil)
        router.dismiss()
    }
}

extension ReminderTemplatesPresenter: ReminderTemplatesInteractorOutput {

    public func remindertemplatesIteractorDidGetRemindPermission(_ interactor: ReminderTemplatesInteractor) {
        callback(viewModel.reminder)
        router.dismiss()
    }

    public func remindertemplatesIteractor(_ interactor: ReminderTemplatesInteractor, didFailGetRemindPermission error: Error?) {
        router.alert(
            title: "An error occured. Try again.",
            message: error?.localizedDescription ?? "") { [weak self] in
                self?.callback(nil)
                self?.router.dismiss()
        }
    }

    public func remindertemplatesIteractorDidDiniedRemindPermission(_ interactor: ReminderTemplatesInteractor) {
        router.alert(
            title: "System access denied",
            message: "In order to use this feature allow to use notifications. You can do it in iOS Settings.") { [weak self] in
                self?.callback(nil)
                self?.router.dismiss()
        }
    }
}
