//
//  DatePickerManualPresenter.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DatePickerManualPresenter: DatePickerManualViewDelegate, DataInitiable {

    public unowned var view: DatePickerManualView
    public var router: DatePickerManualRouter
    public var interactor: DatePickerManualInteractor

    private let callback: DatePickerCallback
    
    public let initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var dateConfig: DatePreferences = .init(assumedDate: DateProvider.current.now, isAllDay: false)
        public var screen: DatePickerManualViewModel.Screen = .calendar
        
        public init() { }
        
        public init(date: DatePreferences?,
                    screen: DatePickerManualViewModel.Screen?) {
            self.dateConfig = date ?? self.dateConfig
            self.screen = screen ?? self.screen
        }
    }
    
    public init(
        view: DatePickerManualView,
        router: DatePickerManualRouter,
        interactor: DatePickerManualInteractor,
        data: InitialData,
        callback: @escaping DatePickerCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        self.callback = callback
        //
        self.interactor.delegate = self
        self.view.delegate = self
    }
    
    private var viewModel: DatePickerManualViewModel {
        get { return view.viewModel }
        set { view.viewModel = newValue }
    }
    
    public func onViewWillAppear() {
        view.display(.init(datePreferences: initialData.dateConfig, mode: initialData.screen))
    }

    public func onViewWillDismiss() {
        callback(nil)
    }

    public func onTouchChangePicker(_ picker: DatePickerManualViewModel.Screen) {
        switch picker {
        case .calendar:
            if viewModel.mode == .calendar, let date = viewModel.date {
                view.scrollToDate(date)
            } else {
                viewModel.mode = .calendar
                view.display(viewModel)
            }
            
        case .time:
            if viewModel.mode == .time {
                let date = resolveTime(selected: DateProvider.current.now)
                viewModel.datePreferences.date = date
                view.scrollToTime(date)
            } else {
                viewModel.datePreferences.isAllDay = false
                viewModel.mode = .time
                view.display(viewModel)
            }
        }
    }

    public func onSelect(date: Date, on screen: DatePickerManualViewModel.Screen) {
        viewModel.datePreferences.date = screen == .calendar ? resolveDate(selected: date) : resolveTime(selected: date)
        viewModel.mode = screen
        view.display(viewModel)
    }
    
    public func onSwitchTime(isAllDay: Bool) {
        viewModel.datePreferences.isAllDay = isAllDay
        viewModel.mode = .calendar
        view.display(viewModel)
    }
    
    public func onTouchSave() {
        router.dismiss { [weak self] in
            guard let result = self?.view.viewModel.datePreferences else { return }
            self?.callback(result)
        }
    }
    
    private var viewModelDate: Date {
        return viewModel.datePreferences.date ?? DateProvider.current.now
    }
    
    private func resolveDate(selected date: Date) -> Date? {
        return Calendar.current.date(bySettingHour: viewModelDate.hour, minute: viewModelDate.minutes, second: viewModelDate.seconds, of: date)
    }

    private func resolveTime(selected date: Date) -> Date {
        return Calendar.current.date(bySettingHour: date.hour, minute: date.minutes, second: date.seconds, of: viewModelDate) ?? DateProvider.current.now
    }
}

extension DatePickerManualPresenter: DatePickerManualInteractorOutput {

}
