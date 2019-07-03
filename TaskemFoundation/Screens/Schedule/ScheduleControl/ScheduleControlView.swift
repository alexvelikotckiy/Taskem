//
//  GroupControlView.swift
//  Taskem
//
//  Created by Wilson on 03/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import Foundation

public protocol ScheduleControlViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchEditing(_ editing: Bool)
    func onTouchClearSelection()
    
    func onTouchNew()
    func onTouch(at index: IndexPath)
    func onSelect(at index: IndexPath)
    func onDeselect(at index: IndexPath)
    func onMove(from source: IndexPath, to destination: IndexPath)
}

public protocol ScheduleControlView: CollectionUpdaterDelegate {
    var delegate: ScheduleControlViewDelegate? { get set }
    var viewModel: ScheduleControlListViewModel { get set }

    func display(_ viewModel: ScheduleControlListViewModel)
    func displaySpinner(_ isVisible: Bool)
    
    func setEditing(_ isEditing: Bool, animated: Bool)
    func resolveSelection(animated: Bool)
}
