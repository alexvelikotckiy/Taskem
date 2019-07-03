//
//  GroupIconPickerPresenter.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public typealias GroupIconPickerCallback = ((Icon?) -> Void)

public class GroupIconPickerPresenter: GroupIconPickerViewDelegate, DataInitiable {
    
    public weak var view: GroupIconPickerView?
    public var router: GroupIconPickerRouter
    public var interactor: GroupIconPickerInteractor

    public let initialData: InitialData
    
    private let callback: GroupIconPickerCallback
    private var wasFirstAppear = false

    public init(
        view: GroupIconPickerView,
        router: GroupIconPickerRouter,
        interactor: GroupIconPickerInteractor,
        data: InitialData,
        callback: @escaping GroupIconPickerCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //
        self.callback = callback
        self.initialData = data
        //
        self.view?.delegate = self
        self.interactor.delegate = self
    }
    
    public struct InitialData: Equatable {
        public var project: Group
        
        public init(project: Group) {
            self.project = project
        }
    }
    
    private var viewModel: GroupIconPickerListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }

    public func onViewWillAppear() {
        if wasFirstAppear {
            view?.display(viewModel: produce(viewModel.selected))
        } else {
            view?.display(viewModel: produce(initialData.project.icon))
            wasFirstAppear = true
        }
        view?.scroll(to: viewModel.selectedIndex)
    }
    
    public func onViewWillDisappear() {
        callback(viewModel.selected)
    }
    
    public func onSelect(at indexPath: IndexPath) {
        let current = viewModel.selectedIndex
        viewModel.cells[current.row].selected = false
        view?.reload(at: current)
        
        viewModel.cells[indexPath.row].selected = true
        view?.reload(at: indexPath)
    }
}

extension GroupIconPickerPresenter {
    private func produce(_ selected: Icon) -> GroupIconPickerListViewModel {
        return .init(
            cells: interactor.allIcons.map { .init(icon: $0, selected: $0 == selected) }
        )
    }
}

extension GroupIconPickerPresenter: GroupIconPickerInteractorOutput {

}
