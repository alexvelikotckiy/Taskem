//
//  ReschedulePresenter.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public class ReschedulePresenter: RescheduleViewDelegate {
    
    public weak var view: RescheduleView?
    public var router: RescheduleRouter
    public var interactor: RescheduleInteractor

    private var wasFirstAppear = false
    
    private var updateSequence: UpdateSequence {
        didSet {
            showAllDoneIfNeed()
        }
    }
        
    public init(
        view: RescheduleView,
        router: RescheduleRouter,
        interactor: RescheduleInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        
        self.updateSequence = .init(updates: [], skip: [])
        //
        self.view?.delegate = self
        self.interactor.interactorDelegate = self
    }
    
    private var viewModel: RescheduleListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private var dataState: DataState = .notLoaded {
        willSet {
            refreshState(dataState)
        }
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            interactor.start()
            wasFirstAppear = true
        }
        reloadAll()
    }
    
    public func onViewWillDisappear() {
        updateSequence.emitChanges()
    }

    public func onSwipe(at index: Int, direction: SwipeDirection) {
        if let overlay = viewModel.overlays.first(where: { $0.action.direction == direction }) {
            let model = viewModel[index].model
            let action = overlay.action
            switch action {
            case .nearestDate, .tomorrow, .weekend, .noDate:
                processChangeDate(for: model, action.resolveDate())
            case .customDate:
                processCalendar(for: model)
            case .skip:
                processSkip(for: model)
            case .complete:
                processToogleCompletion(for: model)
            case .delete:
                processDelete(for: model)
            }
        }
    }
    
    public func onTouchUndoLast() {
        updateSequence.undoLast()
        view?.undoLastSwipe()
    }
    
    private func showAllDoneIfNeed() {
        view?.displayAllDone(updateSequence.updates.count == viewModel.cards.count)
    }
    
    private func showNothingFoundIfNeed() {
        view?.displayNothingFound(viewModel.cards.isEmpty)
    }
    
    private func reloadAll() {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }
        
        dataState = .loading
        
        updateSequence.emitChanges()
        
        let predicate: (TaskModel) -> Bool = { $0.task.isOverdue }
        interactor.fetchTaskModels(predicate) { [weak self] result in
            self?.finishReload(result)
            self?.dataState = .loaded
        }
    }
    
    private func finishReload(_ data: [TaskModel]) {
        view?.display(produce(from:
            .initialize { context in
                context.tasks = data
                context.skip = updateSequence.skip
                context.toolbar = viewModel.toolbar }
            )!
        )
        showNothingFoundIfNeed()
    }
}

private extension ReschedulePresenter {
    private func processSkip(for model: TaskModel) {
        updateSequence.commit(item: model) { _ in }
    }
    
    private func processToogleCompletion(for model: TaskModel) {
        updateSequence.commit(item: model) { [weak self] model in
            guard let strongSelf = self else { return }
            let updates = model.task.change(complete: !model.isComplete)
            strongSelf.interactor.updateTasks([updates])
        }
    }
    
    private func processCalendar(for model: TaskModel) {
        router.presentDatePickerPopup(initialData: .init(dateConfig: model.datePreference)) { [weak self] result in
            guard let strongSelf = self else { return }
            if let datePreference = result {
                strongSelf.processChangeDatePref(for: model, datePreference)
            } else {
                strongSelf.view?.undoLastSwipe()
            }
        }
    }
    
    private func processChangeDatePref(for model: TaskModel, _ datePref: DatePreferences) {
        updateSequence.commit(item: model) { [weak self] model in
            guard let strongSelf = self else { return }
            let updates = model.task.change(datePreferences: datePref)
            strongSelf.interactor.updateTasks([updates])
        }
    }
    
    private func processDelete(for model: TaskModel) {
        updateSequence.commit(item: model) { [weak self] model in
            guard let strongSelf = self else { return }
            strongSelf.interactor.removeTasks([model.id])
        }
    }
    
    private func processChangeDate(for model: TaskModel, _ date: Date?) {
        updateSequence.commit(item: model) { [weak self] model in
            guard let strongSelf = self else { return }
            let updates = model.task.change(assumedDate: date)
            strongSelf.interactor.updateTasks([updates])
        }
    }
}

fileprivate struct UpdateSequence {
    var updates: [Update]
    var skip: [EntityId]
    
    struct Update {
        let item: TaskModel
        let action: (TaskModel) -> Void
        
        init(item: TaskModel,
             _ action: @escaping (TaskModel) -> Void) {
            self.item = item
            self.action = action
        }
    }
    
    mutating func commit(item: TaskModel, _ action: @escaping (TaskModel) -> Void) {
        updates.append(.init(item: item, action))
        skip.append(item.id)
    }
    
    mutating func undoLast() {
        if !updates.isEmpty {
            updates.removeLast()
        }
        if !skip.isEmpty {
            skip.removeLast()
        }
    }
    
    func emitChanges() {
        updates.forEach {
            $0.action($0.item)
        }
    }
    
    mutating func clear() {
        updates.removeAll()
        skip.removeAll()
    }
}

fileprivate extension ReschedulePresenter {
    func refreshState(_ state: DataState) {
        guard self.dataState != state else { return }
        switch state {
        case .loading, .notLoaded:
            view?.displaySpinner(true)
        case .loaded:
            view?.displaySpinner(false)
        }
    }
}

extension ReschedulePresenter: RescheduleInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        switch state {
        case .loaded:
            reloadAll()
        case .loading:
            dataState = .loading
        case .notLoaded:
            break
        }
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        
    }
}
