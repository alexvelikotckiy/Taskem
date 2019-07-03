//
//  TaskNotesPresenter.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public class TaskNotesPresenter: TaskNotesViewDelegate, DataInitiable {

    public unowned var view: TaskNotesView
    public var router: TaskNotesRouter
    public var interactor: TaskNotesInteractor

    public var initialData: InitialData

    private var callback: TaskNotesCallback
    
    public init(
        view: TaskNotesView,
        router: TaskNotesRouter,
        interactor: TaskNotesInteractor,
        data: InitialData,
        callback: @escaping TaskNotesCallback
        ) {
        self.router = router
        self.interactor = interactor
        self.view = view
        //
        self.initialData = data
        self.callback = callback
        //
        self.view.delegate = self
        self.interactor.delegate = self
    }

    public typealias InitialData = TaskOverviewPresenter.InitialData
    
    public func onViewWillAppear() {
        view.display(viewModel: .init(notes: initialData.task.notes))
    }
    
    public func onViewWillDisappear() {
        callback(view.viewModel.notes)
    }
    
    public func onUpdate(notes: String) {
        view.viewModel.notes = notes
    }
}

extension TaskNotesPresenter: TaskNotesInteractorOutput {

}
