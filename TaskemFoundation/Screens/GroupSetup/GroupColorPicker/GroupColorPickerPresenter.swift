//
//  GroupColorPickerPresenter.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public typealias GroupColorPickerCallback = ((Color?) -> Void)

public class GroupColorPickerPresenter: GroupColorPickerViewDelegate, DataInitiable {
    
    public weak var view: GroupColorPickerView?
    public var router: GroupColorPickerRouter
    public var interactor: GroupColorPickerInteractor

    public var initialData: InitialData
    
    private let callback: GroupColorPickerCallback
    private var wasFirstAppear = false
    
    public init(
        view: GroupColorPickerView,
        router: GroupColorPickerRouter,
        interactor: GroupColorPickerInteractor,
        data: InitialData,
        callback: @escaping GroupColorPickerCallback
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
    
    private var viewModel: GroupColorPickerListViewModel {
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }

    public func onViewWillAppear() {
        if wasFirstAppear {
            view?.display(viewModel: produce(viewModel.selected))
        } else {
            view?.display(viewModel: produce(initialData.project.color))
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

extension GroupColorPickerPresenter {
    private func produce(_ selected: Color) -> GroupColorPickerListViewModel {
        return .init(
            cells: Color.TaskemLists.allColors.map { .init(color: Color($0), selected: Color($0) == selected) }
        )
    }
}

extension GroupColorPickerPresenter: GroupColorPickerInteractorOutput {

}
