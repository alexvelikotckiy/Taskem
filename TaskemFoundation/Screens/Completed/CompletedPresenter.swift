//
//  CompletedPresenter.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import UIKit
import Foundation

public class CompletedPresenter: CompletedViewDelegate {
    
    public weak var view: CompletedView?
    public var router: CompletedRouter
    public var interactor: CompletedInteractor

    public var coordinator: TableCoordinatorProtocol!
    
    private var wasFirstAppear = false
    
    public init(
        view: CompletedView,
        router: CompletedRouter,
        interactor: CompletedInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //        
        self.coordinator = TableCoordinator(delegate: view, dataCoordinator: self)
        self.coordinator.observers = [self]
        self.coordinator.pause(cacheChanges: true)
        //
        self.view?.delegate = self
        self.interactor.interactorDelegate = self
    }
    
    private var viewModel: CompletedListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private var dataState: DataState = .notLoaded {
        willSet {
            refreshState(newValue)
        }
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            wasFirstAppear = true
            refreshState(.loading)
            interactor.start()
            coordinator.proceed()
            reloadAll()
        }
    }
    
    public func onTouchClearAll() {
        router.alertDelete(
            title: "Confirm deletion",
            message: "All information about completed tasks will be deleted. Do you want to continue?") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }
                let ids = strongSelf.viewModel.allCells.map { $0.id }
                strongSelf.interactor.removeTasks(ids)
        }
    }
    
    public func onTouchCell(at index: IndexPath, frame: CGRect) {
        router.presentTask(data: .existing(viewModel[index].model), frame: frame)
    }

    public func onToogleCompletion(at index: IndexPath) {
        processUpdateCompletion(for: viewModel[index].model.task)
    }
    
    public func onSwipeRight(at index: IndexPath) {
        processDelete(for: viewModel[index].model.task)
    }
    
    public func onSwipeLeft(at index: IndexPath, _ completion: @escaping () -> Void) {
        let selectedTask = viewModel[index].model.task
        
        router.presentDatePicker(data: .init(dateConfig: selectedTask.datePreference)) { [weak self] result in
            guard let strongSelf = self else { return }
            if let newDate = result {
                strongSelf.processUpdateDatePref(for: selectedTask, datePref: newDate)
            }
            completion()
        }
    }
    
    private func reloadAll() {
        guard wasFirstAppear,
            interactor.sourceTasksState == .loaded else { return }
        
        dataState = .loading
        
        interactor.fetchTaskModels({ $0.isComplete }) { [weak self] data in
            guard let strongSelf = self else { return }

            strongSelf.produceAsync(
                from: .list(
                    data
                ),
                completion: strongSelf.finishReload
            )
        }
    }
    
    private func finishReload(viewModel: CompletedListViewModel?) {
        view?.display(viewModel ?? .init())
        showAllDoneIfNeed()
        dataState = .loaded
    }
}

extension CompletedPresenter {
    private func processUpdateDatePref(for task: Task, datePref: DatePreferences) {
        let updates = task
            .change(datePreferences: datePref)
            .change(complete: false, considerRepeat: false)
        interactor.updateTasks([updates])
    }
    
    private func processUpdateCompletion(for task: Task) {
        let updates = task
            .change(complete: !task.isComplete)
        interactor.updateTasks([updates])
    }
    
    private func processDelete(for task: Task) {
        interactor.removeTasks([task.id])
    }
}

fileprivate extension CompletedPresenter {
    func refreshState(_ state: DataState) {
        switch state {
        case .loading, .notLoaded:
            view?.displayRefresh(true)
        case .loaded:
            view?.displayRefresh(false)
        }
    }
}

extension CompletedPresenter: CompletedInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        dataState = state
        
        switch state {
        case .loaded:
            reloadAll()
        default:
            return
        }
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        coordinator.insert(tasks, silent: false)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        coordinator.update(tasks, silent: false)
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        let predicate: (CompletedViewModel) -> Bool = { return ids.contains($0.id) }
        coordinator.remove(predicate, silent: false)
    }
}
