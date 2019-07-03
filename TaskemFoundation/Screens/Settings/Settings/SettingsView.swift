//
//  SettingsView.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SettingsViewDelegate: class {
    func onViewWillAppear()
    func onSelect(at index: IndexPath)
    func onChangeTime(at index: IndexPath, date: Date)
}

public protocol SettingsView: class {
    var delegate: SettingsViewDelegate? { get set }
    var viewModel: SettingsListViewModel { get set }

    func display(_ viewModel: SettingsListViewModel)
    
    func reloadSections(at indexes: IndexSet, with animation: UITableView.RowAnimation)
    func reloadRows(at indexes: [IndexPath], with animation: UITableView.RowAnimation)
}
