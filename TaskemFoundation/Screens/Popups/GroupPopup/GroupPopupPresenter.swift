//
//  GroupPopupPresenter.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public typealias GroupPopupCallback = (Group?) -> Void

public class GroupPopupPresenter: GroupPopupViewDelegate, DataInitiable {
    
    public unowned var view: GroupPopupView
    public var router: GroupPopupRouter
    public var interactor: GroupPopupInteractor

    private let callback: GroupPopupCallback
    private var wasFirstAppear = false

    public let initialData: InitialData
    
    public struct InitialData: Equatable {
        public var selectedId: EntityId = ""
        
        public init(id: EntityId?) {
            self.selectedId = id ?? self.selectedId
        }
    }
    
    public init(
        view: GroupPopupView,
        router: GroupPopupRouter,
        interactor: GroupPopupInteractor,
        data: InitialData,
        completion: @escaping GroupPopupCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        self.callback = completion
        //
        self.interactor.interactorDelegate = self
        self.view.delegate = self
    }
    
    public func onViewWillAppear() {
        if !wasFirstAppear {
            wasFirstAppear = true
            interactor.start()
        }
        reloadAll()
    }
    
    public func onTouchCancel() {
        callback(nil)
        router.dismiss()
    }
    
    public func onSelect(at index: IndexPath) {
        switch view.viewModel[index] {
            
        case .list(let model):
            callback(model.group)
            router.dismiss()
            
        case .newList(_):
            let new = Group(name: "")
            router.presentNewGroup(.new(new))
        }
    }
    
    private func display(_ viewModel: GroupPopupListViewModel) {
        view.display(viewModel)
    }

    private func reloadAll() {
        let groups = interactor.sourceGroups.allGroups
        let viewModel = produce(groups, selected: initialData.selectedId)
        display(viewModel)
    }
}

private extension GroupPopupPresenter {
    
    func produce(_ groups: [Group], selected: EntityId) -> GroupPopupListViewModel {
        var cells = groups.map { wrapToModel($0, isSelected: selected == $0.id) }
        cells.insert(.newList(.init()), at: 0)
        
        return .init(sections: [.init(cells: cells)])
    }
    
    func wrapToModel(_ group: Group, isSelected: Bool) -> GroupPopupViewModel {
        return .list(.init(group: group, isSelected: isSelected))
    }
}

extension GroupPopupPresenter: GroupPopupInteractorOutput {
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        switch state {
        case .loaded:
            reloadAll()
        default:
            break
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
