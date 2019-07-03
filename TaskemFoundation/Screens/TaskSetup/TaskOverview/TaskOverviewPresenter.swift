//
//  TaskOverviewPresenter.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class TaskOverviewPresenter: TaskOverviewViewDelegate, DataInitiable {
    
    public unowned var view: TaskOverviewView
    public var router: TaskOverviewRouter
    public var interactor: TaskOverviewInteractor

    public let initialData: InitialData
    
    private var wasFirstAppear = false
    private var stateCompletion: (() -> Void)?
    
    private var wasSaved = false
    
    public init(
        view: TaskOverviewView,
        router: TaskOverviewRouter,
        interactor: TaskOverviewInteractor,
        data: InitialData
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        //
        self.view.delegate = self
        self.interactor.interactorDelegate = self
    }
    
    public var state: State = .none {
        willSet {
            refreshState(newValue)
        }
    }
    
    public enum InitialData: Equatable {
        case new(TaskModel)
        case existing(TaskModel)
        
        public var isNew: Bool {
            switch self {
            case .existing:
                return false
            case .new:
                return true
            }
        }
        
        public var id: EntityId {
            switch self {
            case .existing(let value):
                return value.id
            case .new(let value):
                return value.id
            }
        }
        
        public var model: TaskModel {
            switch self {
            case .existing(let value):
                return value
            case .new(let value):
                return value
            }
        }
        
        public var task: Task {
            get {
                switch self {
                case .existing(let value):
                    return value.task
                case .new(let value):
                    return value.task
                }
            }
            set {
                switch self {
                case .existing(var value):
                    value.task = newValue
                    self = .existing(value)
                case .new(var value):
                    value.task = newValue
                    self = .new(value)
                }
            }
        }
        
        public var group: Group {
            get {
                switch self {
                case .existing(let value):
                    return value.group
                case .new(let value):
                    return value.group
                }
            }
            set {
                switch self {
                case .existing(var value):
                    value.group = newValue
                    self = .existing(value)
                case .new(var value):
                    value.group = newValue
                    self = .new(value)
                }
            }
        }
    }
    
    public var model: TaskViewModel {
        return view.viewModel.model
    }
    
    private var viewModel: TaskOverviewListViewModel {
        get { return view.viewModel }
        set { view.viewModel = newValue }
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            interactor.start()
        }
        viewModelReload()
        state = viewModel.editing ? .editing : .none
        wasFirstAppear = true
    }
    
    public func onTouchDelete() {
        guard !viewModel.isNewTask else { return }
        router.alertDelete(
            title: "Confirm deletion",
            message: "All information about the task will be deleted.") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }

                strongSelf.router.dismiss(expandingDismiss: true) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.interactor.removeTasks([strongSelf.viewModel.model.id])
                    strongSelf.wasSaved = true
                }
        }
    }
    
    public func onTouchShare() {
        guard !viewModel.isNewTask else { return }
        interactor.shareTasks([viewModel.model.task])
    }
    
    public func onViewDidDisappear() {
        guard !wasSaved else { return }
        save()
    }
    
    public func onTouchSaveNewTask() {
        guard viewModel.isNewTask else { return }
        router.dismiss(expandingDismiss: true) { [weak self] in
            self?.save()
        }
        wasSaved = true
    }
    
    public func onTouchSaveExistingTask() {
        guard !viewModel.isNewTask else { return }
        router.dismiss(expandingDismiss: true) { [weak self] in
            self?.save()
        }
        wasSaved = true
    }
    
    private func save() {
        switch viewModel.isNewTask {
        case true:
            interactor.insertTasks([viewModel.model.task])
        case false:
            viewModel.model.task.modify(complete: viewModel.model.task.isComplete)
            interactor.updateTasks([viewModel.model.task])
        }
    }
    
    public func onTouchCancel() {
        guard viewModel.isNewTask else { return }
        router.dismiss(expandingDismiss: false) { }
        wasSaved = true
    }
    
    public func onEditingStart() {
        state = .editing
    }
    
    public func onEditingCancel() {
        state = .none
        viewModel.resetChanges()
        viewModelReload()
    }
    
    public func onEditingEnd() {
        state = .none
        viewModel.saveChanges()
    }
    
    public func onChangeName(text: String) {
        viewModel.model.task.name = text
        viewModelReload(shouldDisplay: false)
    }
    
    public func onChangeCompletion(isOn: Bool) {
        viewModel.model.task.modify(complete: isOn, considerRepeat: false)
        viewModelReload()
    }
    
    public func onTouchCell(at index: IndexPath) {
        switch viewModel[index] {
        case .name(_):
            return
            
        case .project(_):
            router.presentGroupPopup(data: .init(id: viewModel.model.group.id)) { [weak self] result in
                guard let strongSelf = self, let result = result else { return }
                strongSelf.viewModel.model.group = result
                strongSelf.viewModelReload()
            }

        case .dateAndTime(_):
            router.presentCalendarPopup(data: .init(dateConfig: viewModel.model.task.datePreference)) { [weak self] result in
                guard let strongSelf = self, let result = result else { return }
                strongSelf.viewModel.model.task.modify(datePreferences: result)
                strongSelf.viewModelReload()
            }

        case .reminders(_):
            router.presentReminderTemplates(data: .init(date: viewModel.model.task.datePreference, reminder: viewModel.model.task.reminder)) { [weak self] result in
                guard let strongSelf = self, let result = result else { return }
                strongSelf.viewModel.model.task.modify(remind: result.trigger)
                strongSelf.viewModelReload()
            }

        case .reiteration(_):
            router.presentRepeatSetup(data: .init(repeat: viewModel.model.task.repeatPreferences)) { [weak self] result in
                guard let strongSelf = self, let result = result else { return }
                strongSelf.viewModel.model.task.repeatPreferences = result
                strongSelf.viewModelReload()
            }

        case .notes(_):
            router.presentTaskNotes(data: viewModel.model) { [weak self] result in
                guard let strongSelf = self, let result = result else { return }
                strongSelf.viewModel.model.task.notes = result
                strongSelf.viewModelReload()
            }
        }
    }
    
    public func onTouchRemoveCell(at index: IndexPath) {
        switch viewModel[index] {
        case .dateAndTime(_):
            viewModel.model.task.modify(datePreferences: .init())
        case .reminders(_):
            viewModel.model.task.modify(remind: .none)
        case .reiteration(_):
            viewModel.model.task.modify(repeat: .none)
        default:
            return
        }
        viewModelReload()
    }
    
    private func viewModelReload(shouldDisplay: Bool = true) {
        if wasFirstAppear {
            viewModel = produce(from: .list(model: viewModel.model, initialData: viewModel.initialData, editing: viewModel.editing))!
        } else {
            viewModel = produce(from: .list(model: initialData, initialData: initialData, editing: initialData.isNew))!
        }
        if shouldDisplay {
            view.display(viewModel: viewModel)
        }
    }
}

extension TaskOverviewPresenter {
    public enum State {
        case none
        case editing
    }
    
    private func refreshState(_ state: State) {
        stateCompletion?()
        
        switch state {
        case .none:
            stateCompletion = nil
            
        case .editing:
            viewModel.editing = true
            
            stateCompletion = { [weak self] in
                self?.viewModel.editing = false
            }
        }
    }
}

extension TaskOverviewPresenter: ViewModelFactory {
    public func produce<T>(from context: TaskOverviewPresenter.Context) -> T? {
        switch context {
        case .list(let model, let initialData, let editing):
            return TaskOverviewListViewModel(
                model: model,
                initialData: initialData,
                editing: editing,
                sections: produce(from: .sections(model: model)) ?? []
                ) as? T
            
        case .sections(let model):
            var cells: [TaskOverviewViewModel] = [
                .name(produce(from: Context.name(model: model))!),
                .notes(produce(from: Context.notes(model: model))!),
                .project(produce(from: Context.project(model: model))!),
                .dateAndTime(produce(from: Context.dateAndTime(model: model))!)
            ]
            if model.model.datePreference.date != nil {
                cells.append(contentsOf: [
                    .reminders(produce(from: Context.reminder(model: model))!),
                    .reiteration(produce(from: Context.repeatition(model: model))!)
                    ]
                )
            }
    
            let sections: [TaskOverviewSectionViewModel] = cells.map { cell in
                switch cell {
                case .name:
                    let footer: String? = {
                        if model.isNew { return nil }
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = .none
                        dateFormatter.dateStyle = .long
                        return dateFormatter.string(from: model.task.creationDate)
                    }()
                    return .init(cells: [cell], footer: footer)
    
                default:
                    return .init(cells: [cell])
                }
            }
            return sections as? T
            
        case .name(let model):
            return TaskOverviewViewModel.Name(model: model.model) as? T
        case .project(let model):
            return TaskOverviewViewModel.Project(model: model.model) as? T
        case .dateAndTime(let model):
            return TaskOverviewViewModel.DateAndTime(model: model.model) as? T
        case .reminder(let model):
            return TaskOverviewViewModel.Reminder(model: model.model) as? T
        case .repeatition(let model):
            return TaskOverviewViewModel.Repeat(model: model.model) as? T
        case .notes(let model):
            return TaskOverviewViewModel.Notes(model: model.model) as? T
        }
    }
    
    public enum Context: Equatable {
        case list           (model: TaskViewModel, initialData: TaskViewModel, editing: Bool)
        case sections       (model: TaskViewModel)
        
        case name           (model: TaskViewModel)
        case project        (model: TaskViewModel)
        case dateAndTime    (model: TaskViewModel)
        case reminder       (model: TaskViewModel)
        case repeatition    (model: TaskViewModel)
        case notes          (model: TaskViewModel)
    }
}

extension TaskOverviewPresenter: TaskOverviewInteractorOutput {
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        
    }
    
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        
    }
}
