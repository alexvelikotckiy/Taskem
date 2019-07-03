//
//  SettingsViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SettingsViewSpy: SettingsView {
    var lastReloadSections: IndexSet?
    var lastReloadRows: [IndexPath]?
    var displayViewModelCallsCount = 0
    
    var delegate: SettingsViewDelegate?
    var viewModel: SettingsListViewModel = .init()
    
    func display(_ viewModel: SettingsListViewModel) {
        self.viewModel = viewModel
        displayViewModelCallsCount += 1
    }
    
    func reloadSections(at indexes: IndexSet, with animation: UITableView.RowAnimation) {
        lastReloadSections = indexes
    }
    
    func reloadRows(at indexes: [IndexPath], with animation: UITableView.RowAnimation) {
        lastReloadRows = indexes
    }
}
