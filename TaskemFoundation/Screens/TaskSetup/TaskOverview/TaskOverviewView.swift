//
//  TaskOverviewView.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskOverviewViewDelegate: class {
    func onViewWillAppear()
    func onViewDidDisappear()

    // An existing task
    func onTouchDelete()
    func onTouchShare()
    func onTouchSaveExistingTask()

    // A new task creation
    func onTouchCancel()
    func onTouchSaveNewTask()
    
    func onEditingCancel()
    func onEditingStart()
    func onEditingEnd()
    
    func onChangeName(text: String)
    func onChangeCompletion(isOn: Bool)
    
    func onTouchCell(at index: IndexPath)
    func onTouchRemoveCell(at index: IndexPath)
}

public protocol TaskOverviewView: class {
    var delegate: TaskOverviewViewDelegate? { get set }
    var viewModel: TaskOverviewListViewModel { get set }

    func display(viewModel: TaskOverviewListViewModel)
    func setEditing(_ editing: Bool, animated: Bool)
}
