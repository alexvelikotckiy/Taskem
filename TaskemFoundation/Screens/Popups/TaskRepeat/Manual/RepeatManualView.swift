//
//  RepeatManualView.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol RepeatManualViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchCell(at index: IndexPath)
    
    func onTouchRepeatType(cellIndex: IndexPath, at index: Int)
    func onTouchDaysOfWeek(cellIndex: IndexPath, at index: Int)
    func onChangeEndDate(cellIndex: IndexPath, date: Date?)
    
    func onTouchSave()
}

public protocol RepeatManualView: class {
    var delegate: RepeatManualViewDelegate? { get set }
    var viewModel: RepeatManualListViewModel { get set }

    func display(_ viewModel: RepeatManualListViewModel)
    func reloadCell(at index: IndexPath, with animation: UITableView.RowAnimation)
    func removeCell(at index: IndexPath)
    func insertCell(at index: IndexPath)
}
