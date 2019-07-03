//
//  DatePickerTemplatesPresenter.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DatePickerTemplatesPresenter: DatePickerTemplatesViewDelegate, DataInitiable {

    public unowned var view: DatePickerTemplatesView
    public var router: DatePickerTemplatesRouter
    public var interactor: DatePickerTemplatesInteractor

    private let userPref: UserPreferencesProtocol
    private let callback: DatePickerCallback
    
    public let initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var dateConfig: DatePreferences = .init()
        
        public init() { }
        
        public init(dateConfig: DatePreferences?) {
            self.dateConfig = dateConfig ?? self.dateConfig
        }
    }
    
    public init(
        view: DatePickerTemplatesView,
        router: DatePickerTemplatesRouter,
        interactor: DatePickerTemplatesInteractor,
        data: InitialData,
        callback: @escaping DatePickerCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        self.callback = callback
        self.userPref = UserPreferences.current
        //
        self.interactor.delegate = self
        self.view.delegate = self
    }
    
    private func display() {
        view.display(produceViewModel())
    }

    private func produceViewModel() -> DatePickerTemplatesListViewModel {
        return .init(sections: [
                .init(cells: [
                        .init(title: "TODAY SOMETIME", template: .todaySometime(Icon(Images.Foundation.icClockLarge))),
                        produceTodayNearestModel(),
                    ]
                ),
                .init(cells: [
                        .init(title: "TOMORROW", template: .tomorrow(description(of: tomorrowDate))),
                        .init(title: "WEEKENDS", template: .weekend(description(of: weekendDate))),
                        .init(title: "MONDAY", template: .monday(description(of: mondayDate))),
                    ]
                ),
                .init(cells: [
                        .init(title: "UNDEFINED", template: .undefined(Icon(Images.Foundation.icCalendarNoneLarge))),
                        .init(title: "CUSTOM", template: .custom(Icon(Images.Foundation.icCalendarCustom))),
                    ]
                )
            ]
        )
    }
    
    private func produceTodayNearestModel() -> DatePickerTemplatesViewModel {
        let now = DateProvider.current.now
        
        switch true {
        case now <= now.morning:
            return .init(title: "MORNING", template: .todayNearest(Icon(Images.Foundation.icMorning),.morning))
            
        case now <= now.noon:
            return .init(title: "NOON", template: .todayNearest(Icon(Images.Foundation.icNoon), .noon))
            
        case now <= now.evening:
            return .init(title: "EVENING", template: .todayNearest(Icon(Images.Foundation.icEvening), .evening))
            
        default:
            return .init(title: "MORNING", template: .todayNearest(Icon(Images.Foundation.icMorning), .morning))
        }
    }

    private var tomorrowDate: Date {
        return Calendar.current.taskem_dateFromDays(DateProvider.current.now, days: 1)
    }
    
    private var weekendDate: Date {
        return Calendar.current.taskem_nextNearestWeekend(after: DateProvider.current.now)?.morning ?? tomorrowDate.morning
    }
    
    private var mondayDate: Date {
        return Calendar.current.taskem_getDay(direction: .forward, "Monday").morning
    }
    
    private func description(of date: Date) -> DatePickerTemplatesViewModel.Description {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        return .init(title: "\(date.day)", subtitle: dateFormatter.string(from: date))
    }
    
    private func resolveDate(for template: DatePickerTemplatesViewModel.Template) -> Date? {
        let calendar = Calendar.current
        let dateProvider = DateProvider.current
        
        switch template {
        case .todaySometime:
            return dateProvider.now

        case .todayNearest(let time):
            switch time {
            case (_, .morning):
                return calendar.taskem_nearestMorning(after: dateProvider.now)
                
            case (_, .noon):
                return calendar.taskem_nearestNoon(after: dateProvider.now)
                
            case (_, .evening):
                return calendar.taskem_nearestEvening(after: dateProvider.now)
            }

        case .tomorrow:
            return calendar.taskem_dateFromDays(dateProvider.now, days: 1)

        case .weekend:
            return calendar.taskem_nextNearestWeekend(after: dateProvider.now)?.morning

        case .monday:
            return calendar.taskem_getDay(direction: .forward, "Monday").morning

        case .undefined:
            return nil

        case .custom:
            return initialData.dateConfig.occurrenceDate ?? dateProvider.now
        }
    }

    public func onViewWillAppear() {
        display()
    }

    public func onViewWillDismiss() {
        callback(nil)
    }

    public func onTouch(at index: IndexPath) {
        switch view.viewModel.cell(index).template {
        case .todaySometime:
            router.presentManual(
                .init(
                    date: .init(assumedDate: DateProvider.current.now, isAllDay: false),
                    screen: .time
                ),
                callback: callback)
            
        case .custom:
            router.presentManual(
                .init(
                    date: initialData.dateConfig,
                    screen: .calendar
                ),
                callback: callback)
            
        default:
            callback(.init(assumedDate: resolveDateForTemplate(at: index), isAllDay: false))
            router.dismiss()
        }
    }

    public func onLongTouch(at index: IndexPath) {
        guard let date = resolveDateForTemplate(at: index) else { return }
        
        router.presentManual(
            .init(
                date: .init(assumedDate: date, isAllDay: false),
                screen: .time
            ),
            callback: callback)
    }
    
    private func resolveDateForTemplate(at index: IndexPath) -> Date? {
        return resolveDate(for: view.viewModel.cell(index).template)
    }
}

extension DatePickerTemplatesPresenter: DatePickerTemplatesInteractorOutput {

}
