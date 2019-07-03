//
//  TaskPopupPresenter.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public class TaskPopupPresenter: TaskPopupViewDelegate, DataInitiable {

    public unowned var view: TaskPopupView
    public var router: TaskPopupRouter
    public var interactor: TaskPopupInteractor
    
    public var factory: TaskPopupViewModelFactory
    
    private var wasFirstAppear = false
    private var wasFirstReload = false
    
    public let initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var name: String?
        public var dateConfig: DatePreferences? = .init()
        public var group: Group?
        public var reminder: Reminder?
        public var repetition: RepeatPreferences?
        
        public init() { }
    }
    
    public init(
        view: TaskPopupView,
        router: TaskPopupRouter,
        interactor: TaskPopupInteractor,
        data: InitialData
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        self.factory = TaskPopupDefaultViewModelFactory()
        //
        self.interactor.interactorDelegate = self
        self.view.delegate = self
    }
    
    private func reloadAll() {
        guard wasFirstAppear else { return }
        
        if wasFirstReload {
            refreshTagProject()
            view.reload()
        } else {
            wasFirstReload = true
            displayViewModel(factory.produce(initialData))
        }
    }
    
    private func refreshTagReminder() {
        if let date = view.viewModel.currentDateAntTime {
            var reminder = view.viewModel.currentReminder ?? .init()
            reminder.trigger.change(absoluteDate: date.date)
            
            if reminder.trigger.absoluteDate != nil {
                view.viewModel.updateOrInsert(factory.produce(reminder))
            }
        } else {
            view.viewModel.remove { $0.tag.isReminderTag }
        }
    }
    
    private func refreshTagProject() {
        let project = view.viewModel.currentProject ?? interactor.sourceGroups.defaultGroup!
        view.viewModel.updateOrInsert(factory.produce(project))
    }
    
    private func addDateTagIfNeed() {
        guard !isContainValidDateTag else { return }
        
        let date = factory.produce(.init(assumedDate: DateProvider.current.now.tomorrow.morning, isAllDay: false))
        view.viewModel.updateOrInsert(date)
    }
    
    private var isContainValidDateTag: Bool {
        if let date = view.viewModel.currentDateAntTime {
            return date.firstOccurrenceDate != nil
        }
        return false
    }
    
    private func displayViewModel(_ viewModel: TaskPopupViewModel) {
        view.display(viewModel)
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            wasFirstAppear = true
            interactor.start()
            reloadAll()
        }
    }
    
    public func onTouchCancel() {
        router.dismiss()
    }

    public func onTouchRemoveTag(at index: Int) {
        switch view.viewModel.tags[index].tag {
        case .project:
            break
            
        case .dateAndTime:
            view.viewModel.remove { $0.tag.isDateAndTimeTag }
            view.viewModel.remove { $0.tag.isReminderTag }
            view.viewModel.remove { $0.tag.isRepetitionTag }
        
        case .reminder:
            view.viewModel.remove { $0.tag.isReminderTag }
            
        case .repetition:
            view.viewModel.remove { $0.tag.isRepetitionTag }
        }
        view.reload()
    }

    public func onTouchAdd() {
        var task = Task(idGroup: "")
        task.name = view.viewModel.name
                
        for item in view.viewModel.tags {
            switch item.tag {
            case .project(let project):
                task.idGroup = project.id

            case .dateAndTime(let date):
                task.modify(datePreferences: date)

            case .reminder(let reminder):
                task.modify(remind: reminder.trigger)

            case .repetition(let repetition):
                task.repeatPreferences = repetition
            }
        }
        interactor.insertTasks([task])
        
        view.viewModel.name = ""
        view.reload()
    }
    
    public func onTouchProject() {
        router.presentGroupPopup(.init(id: view.viewModel.currentProject?.id ?? "")) { [weak self] result in
            guard let strongSelf = self, let result = result else { return }
            
            strongSelf.view.viewModel.updateOrInsert(strongSelf.factory.produce(result))
            strongSelf.view.reload()
        }
    }
    
    public func onTouchCalendar() {
        router.presentCalendarPopup(.init(dateConfig: view.viewModel.currentDateAntTime ?? .init())) { [weak self] result in
            guard let strongSelf = self, let result = result else { return }

            strongSelf.view.viewModel.updateOrInsert(strongSelf.factory.produce(result))
            strongSelf.refreshTagReminder()
            strongSelf.view.reload()
        }
    }

    public func onTouchRepeat() {
        addDateTagIfNeed()
        
        router.presentRepeatPicker(.init(repeat: view.viewModel.currentRepetition ?? .init())) { [weak self] result in
            guard let strongSelf = self, let result = result else { return }

            strongSelf.view.viewModel.updateOrInsert(strongSelf.factory.produce(result))
            strongSelf.view.reload()
        }
    }

    public func onTouchReminder() {
        addDateTagIfNeed()
        
        let date = view.viewModel.currentDateAntTime ?? .init()
        let reminder = view.viewModel.currentReminder ?? .init()
        
        switch date.isAllDay {
        case true:
            router.presentReminderManual(.init(date: date, reminder: reminder), callback: handleReminderCallback)
            
        case false:
            router.presentReminderTemplates(.init(date: date, reminder: reminder), callback: handleReminderCallback)
        }
    }
    
    private func handleReminderCallback(_ result: Reminder?) {
        guard let result = result else { return }
        
        view.viewModel.updateOrInsert(factory.produce(result))
        view.reload()
    }

    public func onChangeName(text: String) {
        view.viewModel.name = text
    }
}

extension TaskPopupPresenter: TaskPopupInteractorOutput {
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        
    }
    
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        switch state {
        case .loaded:
            reloadAll()
        default:
            break
        }
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        reloadAll()
    }
}
