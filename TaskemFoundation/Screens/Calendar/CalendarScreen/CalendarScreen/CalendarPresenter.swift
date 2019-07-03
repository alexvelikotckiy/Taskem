//
//  CalendarPresenter.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import EventKit

public class CalendarPresenter: CalendarViewDelegate {

    public weak var view: CalendarView?
    public var router: CalendarRouter
    public var interactor: CalendarInteractor
    
    public weak var pageDelegate: CalendarPageDelegate?
    
    public var timer: TimerProtocol
    public var dateProvider: DateProviderProtocol = DateProvider.current
    
    public var coordinator: TableCoordinator!
    
    public let config: CalendarConfiguration
    
    private var wasFirstAppear = false
    
    public init(
        view: CalendarView,
        router: CalendarRouter,
        interactor: CalendarInteractor,
        pageDelegate: CalendarPageDelegate
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.config = CalendarPreferences.current
        self.timer = SystemTimer()
        //
        self.coordinator = .init(delegate: view, dataCoordinator: self)
        self.coordinator.observers = [self]
        self.coordinator.pause(cacheChanges: true)
        self.coordinator.configuration.shouldUpdateEqual = false
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChangedConfig),
            name: .CalendarConfigurationDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(syncWithAppleCalendar),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        self.pageDelegate = pageDelegate
        //
        self.interactor.interactorDelegate = self
        self.view?.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var dataState: _DataState = .notLoaded {
        willSet {
            refreshState(newValue)
        }
    }
    
    private var viewModel: CalendarListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    @objc private func onChangedConfig() {
        reloadDifference()
    }
    
    @objc private func syncWithAppleCalendar() {
        reloadDifference()
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            dataState = .loading
            wasFirstAppear = true
            interactor.start()
            startTimer()
            coordinator.proceed()
            reload()
        } else {
            syncWithAppleCalendar()
        }
    }
    
    public func onChange(_ event: EKEvent?) {
        syncWithAppleCalendar()
    }
    
    public func onScroll(at index: IndexPath) {
        let date = viewModel[index.section].date
        viewModel.currentDate = date
        pageDelegate?.didShow(date: date)
    }
    
    public func onChangeDisplayDate(_ date: TimelessDate) {
        viewModel.currentDate = date
        switch viewModel.style {
        case .standard:
            if viewModel.sections.contains(date: date) {
                scroll(to: date)
            } else {
                reload(startingWith: date)
            }
            
        case .bydate:
            reload(startingWith: date)
        }
    }
    
    public func loadPage(at position: PageDirection) {
        guard !dataState.isLoadingPage else { return }

        guard viewModel.style == .standard,
            let start = viewModel.sections.minDate,
            let end = viewModel.sections.maxDate else { return }
        
        dataState = .loadingPage(position)
        
        let loadDate = (position == .top ? start.yesterday : end.tomorrow).timeless
        
        load(startingWith: loadDate, position: position) { [weak self] sections in
            guard let strongSelf = self,
                let sections = sections,
                case let .loadingPage(direction) = strongSelf.dataState else { return }
            
            strongSelf.view?.display(sections: sections, at: direction)
            strongSelf.dataState = .loaded
        }
    }
    
    private func reload(startingWith date: TimelessDate? = nil) {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }
        
        dataState = .loading
        
        load(startingWith: date) { [weak self] viewModel in
            guard let strongSelf = self,
                let viewModel = viewModel else { return }
            
            strongSelf.view?.display(viewModel: viewModel)
            strongSelf.scroll(to: date ?? viewModel.currentDate)
            strongSelf.dataState = .loaded
        }
    }
    
    private func reloadDifference(startingWith date: TimelessDate? = nil) {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }
        
        load(startingWith: date) { [weak self] viewModel in
            guard let strongSelf = self,
                let viewModel = viewModel else { return }
            
            strongSelf.view?.dislpay(difference: viewModel)
        }
    }
    
    private func load(startingWith date: TimelessDate,
                      position: PageDirection,
                      _ completion: @escaping ([CalendarSectionViewModel]?) -> Void) {
        interactor.load(at: date, direction: position, filter: filterPredicate()) { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.produceAsync(
                from: .sections(
                    data: data,
                    interval: nil,
                    style: strongSelf.config.style
                ),
                completion: completion
            )
        }
    }
    
    private func load(startingWith date: TimelessDate? = nil,
                      _ completion: @escaping (CalendarListViewModel?) -> Void) {
        let startDate = date ?? viewModel.currentDate
        let interval: DateInterval?
        
        let onLoad: (CalendarCellsConvertible) -> Void = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.produceAsync(
                from: .list(
                    data: data,
                    interval: nil,
                    style: strongSelf.config.style,
                    initialDate: startDate
                ),
                completion: completion
            )
        }
        
        switch config.style {
        case .bydate:
            interval = DateInterval(start: startDate.value, end: startDate.value.endOfDay)
            interactor.load(
                at: interval!,
                filter: filterPredicate(),
                onLoad
            )
        case .standard:
            interval = nil
            interactor.load(
                at: startDate,
                direction: [.bottom, .top],
                filter: filterPredicate(),
                onLoad
            )
        }
    }
    
    private func scroll(to date: TimelessDate) {
        viewModel.currentDate = date
        guard let index = viewModel.sections.nearest(to: date) else { return }
        view?.scroll(to: index, animated: false)
    }
}

// Swipes and Selection
extension CalendarPresenter {
    public func onTouch(at indexPath: IndexPath, frame: CGRect) {
        switch viewModel[indexPath] {
        case .task(let value):
            router.presentTask(data: .existing(value), frame: frame)

        case .event(let value):
            guard let event = interactor.sourceEventkit.getEvent(matchingId: value.id) else { return }
            router.presentEvent(data: event, frame: frame)

        case .freeday(let value):
            guard let defaultGroup = interactor.sourceGroups.defaultGroup else { return }
            router.presentTaskPopup(data: .initialize {
                $0.group = defaultGroup
                $0.dateConfig = .init(assumedDate: value.date.value, isAllDay: true) }
            )

        case .time:
            return
        }
    }
    
    public func onSwipeLeft(at indexes: [IndexPath],
                            _ completion: @escaping (Bool) -> Void) {
        let data = viewModel.unwrap(at: indexes)
        router.presentDatePicker(data: .init(dateConfig: data.first?.datePreference)) { [weak self] result in
            defer { completion(result != nil) }
            if let result = result {
                self?.change(for: data, result)
            }
        }
    }
    
    public func onSwipeRight(at indexes: [IndexPath]) {
        changeCompletion(for: viewModel.unwrap(at: indexes))
    }
}

// Tasks update
extension CalendarPresenter {
    private func changeCompletion(for tasks: [Task]) {
        let updated = tasks
            .changeToogleCompletion()
        interactor.updateTasks(updated)
    }
    
    private func change(for tasks: [Task], _ datePref: DatePreferences) {
        let updated = tasks
            .change(datePreferences: datePref)
            .change(complete: false, considerRepeat: false)
        interactor.updateTasks(updated)
    }
}

fileprivate extension CalendarPresenter {
    func refreshState(_ state: _DataState) {
        switch state {
        case .loading, .notLoaded:
            view?.displaySpinner(true)
            
        case .loaded:
//            switch dataState {
//            case .loading:
//                scroll(to: viewModel.currentDate)
//
//            default:
//                break
//            }
            view?.displaySpinner(false)
            
        case .loadingPage(_):
            break // TODO
        }
    }
    
    enum _DataState {
        case notLoaded
        case loading
        case loadingPage(PageDirection)
        case loaded
        
        var isLoadingPage: Bool {
            switch self {
            case .loadingPage:
                return true
            default:
                return false
            }
        }
    }
}

extension CalendarPresenter: CalendarInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        if state == .loading {
            dataState = .loading
        }
        if state == .loaded {
            reload()
        }
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        coordinator.update(tasks)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        let predicate: (CalendarCellViewModel) -> Bool = { ids.contains($0.id) }
        coordinator.remove(predicate)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        coordinator.insert(tasks)
    }
    
    public func calendarIteractorDidGetEventKitPermission(_ interactor: CalendarInteractor) {
        reload()
    }
    
    public func calendarIteractorDidDiniedEventKitPermission(_ interactor: CalendarInteractor) {
        router.postAlert(
            title: "Calendar access was denied",
            message: "To syncing with your apple calendar re-enable Calendar access in Settings->Privacy->Calendars."
        )
    }

    public func calendarIteractor(_ interactor: CalendarInteractor, didFailGetEventKitPermission error: Error) {
        router.postAlert(
            title: "An error ocurred while trying to sync with calendar.",
            message: error.localizedDescription
        )
    }
}
