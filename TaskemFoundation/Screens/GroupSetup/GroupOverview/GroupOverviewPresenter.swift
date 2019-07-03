//
//  GroupOverviewPresenter.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class GroupOverviewPresenter: GroupOverviewViewDelegate, DataInitiable {
    
    public weak var view: GroupOverviewView?
    public var router: GroupOverviewRouter
    public var interactor: GroupOverviewInteractor

    public var initialData: InitialData
    
    private var wasFirstAppear = false

    public init(
        view: GroupOverviewView,
        router: GroupOverviewRouter,
        interactor: GroupOverviewInteractor,
        data: InitialData
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.initialData = data
        //
        self.view?.delegate = self
        self.interactor.delegate = self
    }

    public enum InitialData: Equatable {
        case new(Group)
        case existing(Group)
        
        public var id: EntityId {
            switch self {
            case .existing(let project):
                return project.id
            case .new(let project):
                return project.id
            }
        }
        
        public var isNewList: Bool {
            switch self {
            case .existing:
                return false
            case .new:
                return true
            }
        }
        
        public var project: Group {
            switch self {
            case .existing(let project):
                return project
            case .new(let project):
                return project
            }
        }
    }

    private var viewModel: GroupOverviewListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
        
    public func onViewWillAppear() {
        if wasFirstAppear {
            view?.display(viewModel: produce(from: .init(list: viewModel.project, isNew: viewModel.isNewList)))
        } else {
            view?.display(viewModel: produce(from: .init(list: initialData.project, isNew: initialData.isNewList)))
        }
        wasFirstAppear = true
    }

    public func onTouchDelete() {
        router.alertDelete(
            title: "Delete a list: \(viewModel.project.name)?",
            message: "All task in the \(viewModel.project.name) will be deleted") { [weak self] confirmation in
                guard let strongSelf = self, confirmation else { return }
                strongSelf.interactor.removeGroups([strongSelf.viewModel.project.id])
                strongSelf.router.dismiss()
        }
    }

    public func onTouchCancel() {
        router.dismiss()
    }

    public func onTouchCell(at indexPath: IndexPath) {
        guard viewModel.editing else { return }
        
        switch viewModel[indexPath] {
        case .name, .isDefault, .created:
            break
            
        case .icon:
            router.presentIconPicker(.init(project: viewModel.project)) { [weak self] result in
                guard let strongSelf = self,
                    let result = result else { return }
                strongSelf.viewModel.project.icon = result
                strongSelf.viewModelReload()
            }
            
        case .color:
            router.presentColorPicker(.init(project: viewModel.project)) { [weak self] result in
                guard let strongSelf = self,
                    let result = result else { return }
                strongSelf.viewModel.project.color = result
                strongSelf.viewModelReload()
            }
        }
    }

    public func onTouchSave() {
        interactor.insertGroups([viewModel.project])
        router.dismiss()
    }
    
    public func onEditingStart() {
        viewModel.editing = true
    }
    
    public func onEditingEnd() {
        if !viewModel.isNewList, viewModel.hasChanges {
            interactor.updateGroups([viewModel.project])
        }
        viewModel.editing = false
    }
    
    public func onChangeDefault(isOn: Bool) {
        viewModel.project.isDefault = isOn
        viewModelReload()
    }
    
    public func onChangeName(text: String) {
        viewModel.project.name = text
    }
    
    private func viewModelReload() {
        viewModel = produce(from: .init(list: viewModel.project, isNew: viewModel.isNewList))
        view?.display(viewModel: viewModel)
    }
}

extension GroupOverviewPresenter: ViewModelFactory {
    public func produce<T>(from context: GroupOverviewPresenter.Context) -> T? {
        switch true {
        case T.self == GroupOverviewListViewModel.self:
            let value: GroupOverviewListViewModel = produce(from: context)
            return value as? T
        case T.self == [GroupOverviewSectionViewModel].self:
            let value: [GroupOverviewSectionViewModel] = produce(from: context)
            return value as? T
        default:
            return nil
        }
    }
    
    public struct Context: Equatable {
        public var list: Group
        public var isNew: Bool
        
        public init(list: Group,
                    isNew: Bool) {
            self.list = list
            self.isNew = isNew
        }
    }
    
    private func produce(from context: Context) -> GroupOverviewListViewModel {
        return .init(
            sections: produce(from: context),
            initialData: initialData,
            list: context.list,
            editing: context.isNew ? context.isNew : viewModel.editing
        )
    }
    
    private func produce(from context: Context) -> [GroupOverviewSectionViewModel] {
        var sections: [GroupOverviewSectionViewModel] = [
            .init(cells: [
                .name(context.list.name)
                ]
            ),
            .init(cells: [
                .isDefault(context.list.isDefault),
                ]
            ),
            .init(cells: [
                .icon(context.list.icon),
                ]
            ),
            .init(cells: [
                .color(context.list.color),
                ]
            ),
        ]
        
        if !context.isNew {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .long
            sections.append(.init(cells: [
                    .created(dateFormatter.string(from: context.list.creationDate)),
                    ]
                )
            )
        }
        return sections
    }
}

extension GroupOverviewPresenter: GroupOverviewInteractorOutput {
    public func interactorDidChangeStateGroups(_ interactor: GroupSourceInteractor, state: DataState) {
        
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didAdd groups: [Group]) {
        
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdate groups: [Group]) {
        
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didRemoveGroups ids: [EntityId]) {
        
    }
    
    public func interactor(_ interactor: GroupSourceInteractor, didUpdateGroupsOrder ids: [EntityId]) {
        
    }
}
