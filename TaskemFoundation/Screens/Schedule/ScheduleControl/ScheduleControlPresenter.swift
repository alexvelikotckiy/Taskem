//
//  GroupControlPresenter.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public class ScheduleControlPresenter: ScheduleControlViewDelegate {

    public weak var view: ScheduleControlView?
    public var router: ScheduleControlRouter
    public var interactor: ScheduleControlInteractor
    
    public var config: SchedulePreferencesProtocol
    
    private var coordinatorTable: CollectionUpdater!
    
    private var wasFirstAppear = false
    
    public init(
        view: ScheduleControlView,
        router: ScheduleControlRouter,
        interactor: ScheduleControlInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.config = SchedulePreferences.current
        self.coordinatorTable = .init(source: self, delegate: view)
        //
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
    }
    
    private var dataState: DataState = .notLoaded {
        willSet {
            refreshState(newValue)
        }
    }
    
    @objc private func onChangedConfig() {
//        if hasConfigChanges {
//            reloadAll()
//        }
    }
    
    private var viewModel: ScheduleControlListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private var hasConfigChanges: Bool {
        let selectedProjects = config.selectedProjects
        
        for cell in viewModel.allCells {
            if cell.isSelected {
                if selectedProjects.contains(cell.idGroup) {
                    continue
                } else {
                    return true
                }
            } else {
                if selectedProjects.contains(cell.idGroup) {
                    return true
                } else {
                    continue
                }
            }
        }
        return false
    }
    
    private func display(_ viewModel: ScheduleControlListViewModel) {
        guard wasFirstAppear else { return }
        view?.display(viewModel)
    }
    
    private func setSelected(_ isSelected: Bool, at index: IndexPath) {
        viewModel[index].isSelected = isSelected

        if isSelected {
            config.selectedProjects.insert(viewModel[index].idGroup)
        } else {
            config.selectedProjects.remove(viewModel[index].idGroup)
        }
    }
    
    public func onTouchEditing(_ editing: Bool) {
        guard editing != viewModel.isEditing else { return }
        viewModel.isEditing = editing
        view?.setEditing(editing, animated: true)
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            refreshState(.loading)
            wasFirstAppear = true
            coordinatorTable.shouldUpdate = true
            interactor.start()
            reloadAll()
        }
    }

    public func onTouchClearSelection() {
        viewModel.allCells.forEach {
            guard let index = viewModel.index(for: $0) else { return }
            setSelected(false, at: index)
        }
        view?.resolveSelection(animated: true)
    }

    public func onTouch(at index: IndexPath) {
        let project = viewModel[index].group
        router.presentGroupOverview(.existing(project))
    }

    public func onTouchNew() {
        let project = Group(name: "")
        router.presentGroupOverview(.new(project))
    }
    
    public func onSelect(at index: IndexPath) {
        setSelected(true, at: index)
    }

    public func onDeselect(at index: IndexPath) {
        setSelected(false, at: index)
    }

    public func onMove(from source: IndexPath, to destination: IndexPath) {
        let id = viewModel.move(from: source, to: destination).id
        interactor.sourceGroups.reorder(byId: id, source: validateIndex(source).row, destination: validateIndex(destination).row)
    }

    private func validateIndex(_ index: IndexPath) -> IndexPath {
        return viewModel.isEditing ? .init(row: index.row - 1, section: index.section) : index
    }
    
    private func reloadAll() {
        display(produce(from:
            .init(groups: interactor.sourceGroups.allGroups,
                  tasks: interactor.sourceTasks.allTasks,
                  editing: viewModel.isEditing,
                  info: interactor.sourceGroups.info)
            ) ?? .init()
        )
        dataState = .loaded
    }
}

fileprivate extension ScheduleControlPresenter {
    func refreshState(_ state: DataState) {
        switch state {
        case .loading, .notLoaded:
            view?.displaySpinner(true)
        case .loaded:
            view?.displaySpinner(false)
        }
    }
}

extension ScheduleControlPresenter: ScheduleControlInteractorOutput {
    public func interactor(_ interactor: TaskSourceInteractor, didUpdate tasks: [TaskModel]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didRemoveTasks ids: [EntityId]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: TaskSourceInteractor, didAdd tasks: [TaskModel]) {
        reloadAll()
    }
    
    public func interactorDidChangeStateTasks(_ interactor: TaskSourceInteractor, state: DataState) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        reloadAll()
    }
    
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        switch state {
        case .loaded:
            reloadAll()
        default:
            dataState = .loading
        }
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        let currentOrder = viewModel.allCells.map { $0.group.id }
        if ids != currentOrder {
            reloadAll()
        }
    }
}
