//
//  CalendarPagePresenter.swift
//  Taskem
//
//  Created by Wilson on 30/08/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class CalendarPagePresenter: CalendarPageViewDelegate {
    
    public weak var view: CalendarPageView?
    public var router: CalendarPageRouter
    public var interactor: CalendarPageInteractor

    public let config: CalendarConfiguration
    
    private var wasFirstAppear = false
    
    public init(
        view: CalendarPageView,
        router: CalendarPageRouter,
        interactor: CalendarPageInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.config = CalendarPreferences.current
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChangedConfig),
            name: .CalendarConfigurationDidChange,
            object: nil
        )
        //
        self.view?.viewDelegate = self
        self.interactor.interactorDelegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func onChangedConfig() {
        reloadAll()
    }
    
    private var viewModel: CalendarPageViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func reloadAll() {
        view?.display(viewModel: produce(from: .model(viewModel.currentDate, config.style))!)
        view?.displayCalendar(shouldHide: viewModel.shouldHideCalendarOnWeekScope,
                              animated: wasFirstAppear)
        view?.reloadCalendar()
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            interactor.start()
            reloadAll()
            wasFirstAppear = true
        } else {
            reloadAll()
        }
    }
    
    public func onTouchCalendarControl() {
        router.presentCalendarControl()
    }
    
    public func onTouchDots() {
        router.presentPopMenu()
    }
    
    public func onTouchToday() {
        guard Date.now.timeless != viewModel.currentDate else { return }
        onTouchCalendar(on: Date.now)
        view?.diplayCalendar(at: Date.now.timeless)
    }
    
    public func onRefresh() {
        interactor.restart()
    }
    
    public func onCalendarType(_ type: CalendarStyle) {
        config.style = type
    }
    
    public func onShowCompleted(_ isShow: Bool) {
        config.showCompleted = isShow
    }
    
    public func onTouchPlus(isLongTap: Bool) {
        guard let defaultGroup = interactor.sourceGroups.defaultGroup else { return }
        if isLongTap {
            router.presentTask(initialData:
                .new(.init(
                    task: .init(idGroup: defaultGroup.id),
                    group: defaultGroup)
                )
            )
        } else {
            router.presentTaskPopup(initialData:
                .initialize {
                    $0.group = defaultGroup
                    $0.dateConfig = .init(assumedDate: viewModel.currentDate.value, isAllDay: true)
                }
            )
        }
    }
    
    public func onTouchCalendar(on date: Date) {
        let currentDate = viewModel.currentDate
        let nextDate = date.timeless

        viewModel.currentDate = nextDate
        view?.display(title: produce(from: .title(nextDate))!)

        switch config.style {
        case .standard:
            view?.displayCurrentPage(date: nextDate)

        case .bydate:
            guard nextDate != currentDate else { return }
            view?.displayNextPage(date: nextDate, direction: nextDate > currentDate ? .forward : .reverse)
        }
    }
    
    public func didShowCalendar(page: CalendarPage) {
        didShow(date: page.currentDate)
    }
    
    public func didShowCalendarPage(_ date: Date) {
        view?.display(title: produce(from: .title(date.timeless))!)
    }
    
    public func hasEvents(on date: Date) -> Bool {
        return interactor.hasEvents(at:
            DateInterval(
                start: date.startOfDay,
                end: date.endOfDay
            )
        )
    }
    
    public func configurePage<T>(_ nextPage: T,
                                 direction: CalendarPageDirection,
                                 currentPage: CalendarPage) -> T? where T : CalendarPage {
        guard viewModel.calendarType == .bydate else { return nil }
        switch direction {
        case .forward:
            nextPage.currentDate = currentPage.currentDate.value.tomorrow.timeless
        case .reverse:
            nextPage.currentDate = currentPage.currentDate.value.yesterday.timeless
        }
        return nextPage
    }
}

extension CalendarPagePresenter: CalendarPageDelegate {
    public func didShow(date: TimelessDate) {
        viewModel.currentDate = date
        view?.display(title: produce(from: .title(date))!)
        view?.diplayCalendar(at: date)
    }
}

extension CalendarPagePresenter: ViewModelFactory {
    public func produce<T>(from context: CalendarPagePresenter.Context) -> T? {
        switch context {
        case .model(let date, let style):
            return model(date, style) as? T
        case .title(let date):
            return title(date) as? T
        }
    }
    
    public enum Context {
        case model(TimelessDate, CalendarStyle)
        case title(TimelessDate)
    }
    
    private func model(_ date: TimelessDate, _ style: CalendarStyle) -> CalendarPageViewModel {
        return .init(
            currentDate: date,
            calendarType: style,
            title: title(date)
        )
    }
    
    private func title(_ date: TimelessDate) -> String {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM YYYY"
            return formatter
        }()
        return dateFormatter.string(from: date.value)
    }
}

extension CalendarPagePresenter: CalendarPageInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        switch state {
        case .loaded:
            view?.reloadCalendar()
        default:
            break
        }
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        view?.reloadCalendar()
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        view?.reloadCalendar()
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        view?.reloadCalendar()
    }
}
