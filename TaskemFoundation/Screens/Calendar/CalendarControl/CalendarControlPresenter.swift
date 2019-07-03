//
//  CalendarControlPresenter.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class CalendarControlPresenter: CalendarControlViewDelegate {
    
    public weak var view: CalendarControlView?
    public var router: CalendarControlRouter
    public var interactor: CalendarControlInteractor
    
    public let config: CalendarConfiguration
    
    private var wasFirstAppear = false
    
    public init(
        view: CalendarControlView,
        router: CalendarControlRouter,
        interactor: CalendarControlInteractor
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
        self.view?.delegate = self
        self.interactor.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func onChangedConfig() {
        if hasConfigChanges() {
            reloadAll()
        }
    }
    
    private var viewModel: CalendarControlListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func hasConfigChanges() -> Bool {
        for cell in viewModel.allCells {
            switch cell {
            case .group(let model):
                if model.isSelected && config.unselectedTaskemGroups.contains(model.group.id) {
                    return true
                }

            case .calendar(let model):
                if model.isSelected && config.unselectedAppleCalendars.contains(model.calendar.id) {
                    return true
                }
            }
        }
        return false
    }

    private func reloadAll() {
        guard wasFirstAppear,
            interactor.sourceGroupsState == .loaded else { return }
        
        interactor.nextFetch { [weak self] lists, calendars in
            guard let strongSelf = self else { return }
            strongSelf.view?.display(viewModel:
                strongSelf.produce(from: .init(lists: lists, calendars: calendars)) ?? .init()
            )
        }
    }
    
    private func setSelected(cell: CalendarControlViewModel, isSelected: Bool) {
        guard let index = viewModel.index(for: cell) else { return }
        viewModel[index].isSelected = isSelected
        
        switch viewModel[index] {
        case .calendar(let value):
            if isSelected {
                config.unselectedAppleCalendars.remove(value.calendar.id)
            } else {
                config.unselectedAppleCalendars.insert(value.calendar.id)
            }
            
        case .group(let value):
            if isSelected {
                config.unselectedTaskemGroups.remove(value.group.id)
            } else {
                config.unselectedTaskemGroups.insert(value.group.id)
            }
        }
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            interactor.start()
            wasFirstAppear = true
        }
        reloadAll()
    }

    public func onTouchDone() {
        router.dismiss()
    }
    
    public func onTouchToogleAll() {
        config.pause(onCompletion: .CalendarConfigurationDidChange) {
            let unselectedCount = config.unselectedTaskemGroups.count + config.unselectedAppleCalendars.count
            viewModel.allCells.forEach {
                setSelected(cell: $0, isSelected: unselectedCount != 0)
            }
            view?.resolveSelection(animated: true)
        }
    }

    public func onSelect(at index: IndexPath) {
        setSelected(cell: viewModel[index], isSelected: true)
    }
    
    public func onDeselect(at index: IndexPath) {
        setSelected(cell: viewModel[index], isSelected: false)
    }
}

extension CalendarControlPresenter: CalendarControlInteractorOutput {
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        if state == .loaded {
            reloadAll()
        }
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        reloadAll()
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        reloadAll()
    }
}
