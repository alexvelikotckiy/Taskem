//
//  ScheduleViewController+Searching.swift
//  Taskem
//
//  Created by Wilson on 12/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension ScheduleViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        prepareUI(isSearching: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        delegate?.onSearch(searchController.searchBar.text ?? "")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        prepareUI(isSearching: false)
        delegate?.onEndSearch()
    }
}

extension ScheduleViewController {
    func prepareUI(isSearching: Bool) {
        preparePlus(isSearching)
        prepareTable(isSearching)
        prepareNavBar(isSearching)
    }
    
    private func prepareTable(_ searching: Bool) {
        if searching {
            var insets = tableView.defaultSafeAreaInsets(in: self)
            insets.top = searchController.searchBar.frame.height
            tableView.contentInset = insets
            tableView.bounces = false
        } else {
            tableView.contentInset = tableView.defaultSafeAreaInsets(in: self)
            tableView.bounces = true
        }
        tableView.reloadData()
    }
    
    private func prepareNavBar(_ searching: Bool) {
        navigationController?.setNavigationBarHidden(searching, animated: true)
    }
    
    private func preparePlus(_ searching: Bool) {
        plusButton.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.plusButton.alpha = searching ? 0 : 1
            self.plusButton.transform = searching ? .init(scaleX: 0.9, y: 0.9) : .identity
        }
        animator.addCompletion { position in
            if position == .end {
                self.plusButton.isHidden = searching
            }
        }
        animator.startAnimation()
    }
}
