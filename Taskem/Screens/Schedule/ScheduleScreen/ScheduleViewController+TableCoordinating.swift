//
//  ScheduleViewController+TableCoordinating.swift
//  Taskem
//
//  Created by Wilson on 12/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension ScheduleViewController: TableCoordinatorDelegate {
    func didBeginUpdate() {
        
    }
    
    func didEndUpdate() {
        currentSwipingCell = nil
        processChangeSelection()
    }
    
    func insertSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.insertSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.deleteSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    func willBeginUpdate(at index: IndexPath) {
        let index = tableView.dataSourceIndexPath(fromVisibleIndexPath: index)!
        let key = viewModel[index].id
        tableView.fd_keyedHeightCache.invalidateHeight(forKey: key as NSCopying)
    }
    
    func willEndUpdate(at index: IndexPath) {
        
    }
    
    func insertRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.insertRows(at: visible(from: indexes), with: .automatic)
        tableView.endUpdates()
    }
    
    func updateRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.reloadRows(at: visible(from: indexes), with: .automatic)
        tableView.endUpdates()
    }
    
    func deleteRows(at indexes: [IndexPath]) {
        tableView.beginUpdates()
        tableView.deleteRows(at: visible(from: indexes), with: .automatic)
        tableView.endUpdates()
    }
    
    func moveRow(from: IndexPath, to index: IndexPath) {
        tableView.beginUpdates()
        if viewModel.sections[index.section].isExpanded {
            tableView.moveRow(at: from, to: index)
        } else {
            tableView.deleteRows(at: [from], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func reloadSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
    
    private func visible(from indexes: [IndexPath]) -> [IndexPath] {
        return indexes.filter { viewModel.sections[$0.section].isExpanded }
    }
}
