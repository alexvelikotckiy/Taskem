//
//  DefaultGroupPickerPresenter.swift
//  Taskem
//
//  Created by Wilson on 27/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class DefaultGroupPickerPresenter: DefaultGroupPickerViewDelegate {
    
    public unowned var view: DefaultGroupPickerView
    public var router: DefaultGroupPickerRouter
    public var interactor: DefaultGroupPickerInteractor
    
    public init(
        view: DefaultGroupPickerView,
        router: DefaultGroupPickerRouter,
        interactor: DefaultGroupPickerInteractor
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.view.delegate = self
        self.interactor.interactorDelegate = self
    }
    
    public func onViewWillAppear() {
        interactor.start()
        reloadAll()
    }

    public func onSelect(at index: Int) {
        if let currentDefault = findDefault(), index != currentDefault {
            setDefault(false, at: currentDefault)
        }
        setDefault(true, at: index)
    }
    
    private func findDefault() -> Int? {
        return view.viewModel.cells.firstIndex(where: { $0.group.isDefault })
    }
    
    private func setDefault(_ isDefault: Bool, at index: Int) {
        view.viewModel.cells[index].group.isDefault = isDefault
        view.reload(at: index)
        
        if isDefault {
            let id = view.viewModel.cell(for: index).group.id
            interactor.setDefaultGroup(id)
        }
    }
    
    private func reloadAll() {
        let viewModel = produce(interactor.sourceGroups.allGroups)
        if viewModel != view.viewModel {
            view.display(viewModel)
        }
    }
}

private extension DefaultGroupPickerPresenter {
    func produce(_ groups: [Group]) -> DefaultGroupPickerListViewModel {
        return .init(cells: groups.map { .init(group: $0) })
    }
}

fileprivate extension DefaultGroupPickerPresenter {
    enum State {
        case notLoaded
        case loading
        case loaded
    }
    
    func refreshState(_ state: State) {
        switch state {
        case .loading, .notLoaded:
            view.displaySpinner(true)
        case .loaded:
            view.displaySpinner(false)
        }
    }
}

extension DefaultGroupPickerPresenter: DefaultGroupPickerInteractorOutput {
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        reloadAll()
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
