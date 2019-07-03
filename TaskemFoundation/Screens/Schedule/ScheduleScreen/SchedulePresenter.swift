//
//  SchedulePresenter.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import Foundation

public class SchedulePresenter: ScheduleViewDelegate {
    
    public weak var view: ScheduleView?
    public var router: ScheduleRouter
    public var interactor: ScheduleInteractor
    
    public var coordinator: TableCoordinatorProtocol!
    
    public var timer: TimerProtocol
    public var dateProvider: DateProviderProtocol = DateProvider.current
    
    public let config: SchedulePreferencesProtocol
    
    private var wasFirstAppear = false
    
    private var shouldExpandAllSections = false
    private var shouldToogleSections = true
    
    private var stateCompletion: (() -> Void)?
    
    public init(
        view: ScheduleView,
        router: ScheduleRouter,
        interactor: ScheduleInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.config = SchedulePreferences.current
        self.dateProvider = DateProvider.current
        self.timer = SystemTimer()
        //
        self.coordinator = TableCoordinator(delegate: view, dataCoordinator: self)
        self.coordinator.observers = [self]
        self.coordinator.pause(cacheChanges: true)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChangedConfig),
            name: .ScheduleConfigurationDidChange,
            object: nil
        )

        self.view?.delegate = self
        self.interactor.interactorDelegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        stopTimer()
    }

    public var state: State = .none {
        willSet {
            refreshState(newValue)
        }
    }
    
    public var dataState: DataState = .notLoaded {
        willSet {
            refreshState(newValue)
        }
    }
    
    private var viewModel: ScheduleListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    @objc private func onChangedConfig() {
        reloadAll()
    }
    
    private func reloadAll() {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }

        dataState = .loading

        switch config.selectedProjects.isEmpty {
        case true:
            interactor.fetchTaskModels { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.produceAsync(
                    from: .list(
                        data,
                        strongSelf.config.typePreference,
                        strongSelf.interactor.sourceGroups.allGroups,
                        strongSelf.shouldExpandAllSections
                    ),
                    completion: strongSelf.finishReload
                )
            }

        case false:
            let selectedProjects = config.selectedProjects.array
            interactor.fetchTaskModels({ selectedProjects.contains($0.idGroup) }) { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.produceAsync(
                    from: .list(
                        data,
                        strongSelf.config.typePreference,
                        strongSelf.interactor.sourceGroups.allGroups,
                        strongSelf.shouldExpandAllSections
                    ),
                    completion: strongSelf.finishReload
                )
            }
        }
    }

    private func recreateAll() {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }

        produceAsync(
            from: .list(
                viewModel.allTasksModel,
                config.typePreference,
                interactor.sourceGroups.allGroups,
                shouldExpandAllSections
            ),
            completion: finishReload
        )
    }

    private func finishReload(viewModel: ScheduleListViewModel?) {
        view?.display(viewModel: viewModel ?? .init())
        dataState = .loaded
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            dataState = .loading
            wasFirstAppear = true
            interactor.start()
            startTimer()
            coordinator.proceed()
            reloadAll()
        }
    }
}

extension SchedulePresenter {
    public enum State: Equatable {
        case none
        case editing
        case searching(String)
    }
    
    private func refreshState(_ state: State) {
        stateCompletion?()
        
        switch state {
        case .none:
            stateCompletion = nil
            
        case .editing:
            shouldExpandAllSections = true
            shouldToogleSections = false
            
            viewModel.toogleSections(expanded: true)
            view?.reloadSections(at: viewModel.sectionsIndexes)
            
            stateCompletion = { [weak self] in
                guard let strongSelf = self else { return }
                self?.shouldToogleSections = true
                self?.shouldExpandAllSections = false
                self?.viewModel.toogleSections(resolvedBy: strongSelf.config)
                self?.view?.reloadSections(at: self?.viewModel.sectionsIndexes ?? .init())
            }
            
        case .searching(let searchText):
            shouldExpandAllSections = true
            shouldToogleSections = false
            
            switch self.state {
            case .searching(let prevSearchText):
                if searchText != prevSearchText {
                    reloadAll()
                }
                
            default:
                viewModel.toogleSections(expanded: true)
                view?.reloadSections(at: viewModel.sectionsIndexes)
                
                router.presentSearch()
                
                stateCompletion = { [weak self] in
                    self?.shouldToogleSections = true
                    self?.shouldExpandAllSections = false
                    self?.reloadAll()
                }
            }
        }
    }
}

private extension SchedulePresenter {
    func refreshState(_ state: DataState) {
        switch state {
        case .loading, .notLoaded:
            view?.displaySpinner(true)
        case .loaded:
            view?.displaySpinner(false)
        }
        showAllDoneIfNeed()
        showNotFoundIfNeed()
        
        viewModel.onChangeSectionCount = { [weak self] in
            self?.showAllDoneIfNeed()
            self?.showNotFoundIfNeed()
        }
    }
}

// Tasks update
extension SchedulePresenter {
    private func processToogleCompletion(for tasks: [Task]) {
        let updates = tasks
            .changeToogleCompletion()
        interactor.updateTasks(updates)
    }
    
    private func processUpdateDatePref(for tasks: [Task], _ datePref: DatePreferences) {
        let updates = tasks
            .change(datePreferences: datePref)
            .change(complete: false, considerRepeat: false)
        interactor.updateTasks(updates)
    }
    
    private func processUpdateProject(for tasks: [Task], _ project: Group) {
        let updates = tasks
            .change(idGroup: project.id)
        interactor.updateTasks(updates)
    }
}

// Interface interaction
extension SchedulePresenter {
    public func onRefresh() {
        interactor.restart()
    }
    
    public func onTouchScheduleControl() {
        router.presentScheduleControl()
    }
    
    public func onTouchThreeDots() {
        router.presentPopMenu()
    }
    
    public func onChangeSorting(_ sorting: ScheduleTableType) {
        config.typePreference = sorting
    }
    
    public func onTouch(at indexPath: IndexPath, frame: CGRect) {
        switch viewModel[indexPath] {
        case .task(let value):
            router.presentTask(initialData: .existing(value), frame: frame)
        case .time:
            break
        }
    }
    
    public func onTouchPlus(isLongTap: Bool) {
        guard let defaultGroup = interactor.sourceGroups.defaultGroup else { return }
        if isLongTap {
            router.presentTask(
                initialData: .new(.init(task: .init(idGroup: defaultGroup.id),group: defaultGroup)),
                frame: nil
            )
        } else {
            router.presentTaskPopup(initialData:
                .initialize {
                    $0.group = defaultGroup
                    $0.dateConfig = .init(assumedDate: nil, isAllDay: true)
                }
            )
        }
    }
}

// Swipes
extension SchedulePresenter {
    public func onSwipeLeft(at indexes: [IndexPath], _ completion: @escaping (Bool) -> Void) {
        guard !indexes.isEmpty else { return }
        
        let selected = viewModel.unwrap(at: indexes)
        router.presentDatePickerPopup(initialData: .init(dateConfig: selected.first?.datePreference ?? .init())) { [weak self] result in
            if let result = result {
                self?.processUpdateDatePref(for: selected, result)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func onSwipeRight(at indexes: [IndexPath]) {
        processToogleCompletion(for: viewModel.unwrap(at: indexes))
    }
}

// Searching
extension SchedulePresenter {
    public func onBeginSearch() {
        state = .searching("")
    }
    
    public func onEndSearch() {
        state = .none
    }
    
    public func onSearch(_ text: String) {
        state = .searching(text)
    }
}

// Editing
extension SchedulePresenter {
    public func onBeginEditing() {
        state = .editing
    }
    
    public func onEndEditing() {
        state = .none
    }
    
    public func onEditDelete(at indexes: [IndexPath]) {
        postDeleteAlert(viewModel.ids(for: indexes))
    }
    
    public func onShare(at indexes: [IndexPath]) {
        interactor.shareTasks(viewModel.unwrap(at: indexes))
    }
    
    public func onEditGroup(at indexes: [IndexPath]) {
        let selected = viewModel.unwrap(at: indexes)
        let id = selected.first?.idGroup
        
        router.presentGroupPopup(initialData: .init(id: id)) { [weak self] result in
            guard let result = result,
                let strongSelf = self else { return }
            strongSelf.processUpdateProject(for: selected, result)
        }
    }
}

// Reordering
extension SchedulePresenter {
    public func onReorderingWillBegin(initial: IndexPath) {
        coordinator.pause(cacheChanges: true)
    }
    
    public func onReorderingDidEnd(source: IndexPath, destination: IndexPath) {
        let cell = viewModel.move(from: source, to: destination)

        switch config.typePreference {
        case .schedule:
            if case .schedule(let status) = viewModel.sections[destination.section].type { finishReordering(cell, to: status) }
        case .project:
            if case .project(let id) = viewModel.sections[destination.section].type { finishReordering(cell, to: id) }
        case .flat:
            if case .flat(let status) = viewModel.sections[destination.section].type { finishReordering(cell, to: status) }
        }
        coordinator.proceed()
    }
    
    private func finishReordering(_ cell: ScheduleCellViewModel, to destinationStatus: ScheduleSection) {
        switch cell {
        case .task(let item):
            if destinationStatus == item.status {
                if destinationStatus == .overdue {
                    postIncorrectReorder()
                }
                resetPosition(cell)
            } else {
                switch destinationStatus {
                case .overdue,
                     .complete where item.status == .complete:
                    postIncorrectReorder()
                    resetPosition(cell)

                default:
                    let updates = item.task
                        .change(status: destinationStatus)
                    interactor.updateTasks([updates])
                }
            }
        case .time:
            break
        }
    }
    
    private func finishReordering(_ cell: ScheduleCellViewModel, to destinationGroupId: EntityId) {
        switch cell {
        case .task(let item):
            switch destinationGroupId {
            case item.idGroup:
                resetPosition(cell)
                
            default:
                let updates = item.task
                    .change(idGroup: destinationGroupId)
                interactor.updateTasks([updates])
            }
        case .time:
            break
        }
    }
    
    private func finishReordering(_ cell: ScheduleCellViewModel, to destinationStatus: ScheduleFlatSection) {
        switch cell {
        case .task(let item):
            switch destinationStatus {
            case item.flatStatus:
                resetPosition(cell)
                
            default:
                let updates = item.task
                    .change(status: destinationStatus)
                interactor.updateTasks([updates])
            }

        case .time:
            break
        }
    }
    
    private func resetPosition(_ cell: ScheduleCellViewModel) {
        coordinator.update([.make(new: cell, old: cell)], silent: false)
    }
}

// Header actions
extension SchedulePresenter {
    public func onTouchHeaderAction(with type: ScheduleSectionType) {
        switch viewModel.type {
        case .schedule:
            if case .schedule(let status) = type { processHeaderAction(status) }
        case .project:
            if case .project(let id) = type { processHeaderAction(id) }
        case .flat:
            if case .flat(let flatStatus) = type { processHeaderAction(flatStatus) }
        }
    }
    
    private func processHeaderAction(_ status: ScheduleSection) {
        switch status {
        case .overdue:
            router.presentReschedule()

        case .complete:
            postDeleteCompletedTaskAlert()
            
        default:
            router.presentTaskPopup(initialData:
                .initialize {
                    $0.group = interactor.findGroupDefault()
                    $0.dateConfig = .init(assumedDate: status.statusToDate(), isAllDay: true)
                }
            )
        }
    }
    
    private func processHeaderAction(_ id: EntityId) {
        router.presentTaskPopup(initialData:
            .initialize {
                $0.group = interactor.findGroup(by: id)
            }
        )
    }
    
    private func processHeaderAction(_ flatStatus: ScheduleFlatSection) {
        switch flatStatus {
        case .complete:
            postDeleteCompletedTaskAlert()
            
        case .uncomplete:
            router.presentTaskPopup(initialData:
                .initialize {
                    $0.group = interactor.findGroupDefault()
                    $0.dateConfig = .init(assumedDate: nil, isAllDay: true)
                }
            )
        }
    }
}

// Sections toogle(expanded/unexpanded)
extension SchedulePresenter {
    public func onTouchToogleHeader(with type: ScheduleSectionType) {
        guard shouldToogleSections else { return }
        
        var sectionIndex: Int?

        switch type {
        case let .schedule(status):
            guard let index = viewModel.sections.firstIndex(where: { $0.type.unwrapSchedule() == status }) else { break }
            scheduleToogleIsExpanded(viewModel: viewModel, at: [index])
            sectionIndex = index

        case let .project(id):
            guard let index = viewModel.sections.firstIndex(where: { $0.type.unwrapProject() == id }) else { break }
            projectToogleIsExpanded(viewModel: viewModel, at: [index])
            sectionIndex = index

        case let .flat(flatStatus):
            guard let index = viewModel.sections.firstIndex(where: { $0.type.unwrapFlat() == flatStatus }) else { break }
            flatToogleIsExpanded(viewModel: viewModel, at: [index])
            sectionIndex = index
        }

        if let index = sectionIndex {
            view?.reloadSections(at: .init(integer: index))
        }
    }
    
    private func scheduleToogleIsExpanded(viewModel: ScheduleListViewModel, at indexes: [Int]) {
        for index in indexes {
            let section = viewModel.sections[index]

            if case .schedule(let status) = section.type {
                var scheduleUnexpanded = config.scheduleUnexpanded

                if scheduleUnexpanded.contains(status) {
                    scheduleUnexpanded.remove(status)
                } else {
                    scheduleUnexpanded.insert(status)
                }
                section.isExpanded = !scheduleUnexpanded.contains(status)

                config.scheduleUnexpanded = scheduleUnexpanded
            }
        }
    }

    private func projectToogleIsExpanded(viewModel: ScheduleListViewModel, at indexes: [Int]) {
        for index in indexes {
            let section = viewModel.sections[index]

            if case .project(let id) = section.type {
                var projectsUnexpanded = config.projectsUnexpanded

                if projectsUnexpanded.contains(id) {
                    projectsUnexpanded.remove(id)
                } else {
                    projectsUnexpanded.insert(id)
                }
                section.isExpanded = !projectsUnexpanded.contains(id)

                config.projectsUnexpanded = projectsUnexpanded
            }
        }
    }

    private func flatToogleIsExpanded(viewModel: ScheduleListViewModel, at indexes: [Int]) {
        for index in indexes {
            let section = viewModel.sections[index]

            if case .flat(let flatStatus) = section.type {
                var flatUnexpanded = config.flatUnexpanded

                if flatUnexpanded.contains(flatStatus) {
                    flatUnexpanded.remove(flatStatus)
                } else {
                    flatUnexpanded.insert(flatStatus)
                }
                section.isExpanded = !flatUnexpanded.contains(flatStatus)

                config.flatUnexpanded = flatUnexpanded
            }
        }
    }
}

private extension SchedulePresenter {
    private func postDeleteCompletedTaskAlert() {
        postDeleteAlert(viewModel.allCompletedTasks.map { $0.id })
    }
    
    private func postIncorrectReorder() {
        router.alertView(message: "You can't reorder a task to this section.")
    }
    
    private func postDeleteAlert(_ ids: [EntityId]) {
        router.alertDelete(
            title: "Confirm deletion",
            message: "All information about selected tasks will be deleted. Do you want to continue?") { [weak self] confirmation in
                guard confirmation, let strongSelf = self else { return }
                strongSelf.interactor.removeTasks(ids)
        }
    }
}

extension SchedulePresenter: ScheduleInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        if state == .loading {
            dataState = state
        }
        if state == .loaded {
            reloadAll()
        }
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
         coordinator.insert(tasks, silent: false)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        coordinator.update(tasks, silent: false)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        let predicate: (ScheduleCellViewModel) -> Bool = { return ids.contains($0.id) }
        coordinator.remove(predicate, silent: false)
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        guard config.typePreference == .project else { return }
        recreateAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        guard config.typePreference == .project else { return }
        recreateAll()
    }
}
