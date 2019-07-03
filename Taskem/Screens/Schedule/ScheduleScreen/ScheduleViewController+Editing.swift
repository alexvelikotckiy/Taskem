//
//  ScheduleViewController+Editing.swift
//  Taskem
//
//  Created by Wilson on 12/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension ScheduleViewController {
    func prepareUI(isEditing: Bool) {
        prepareTabbar(isEditing)
        prepareTableView(isEditing)
        prepareToolbar(isEditing)
        prepareNavBar(isEditing)
        preparePlus(isEditing)
    }
    
    private func prepareTableView(_ editing: Bool) {
        tableView.allowsMultipleSelection = editing
        tableView.reloadData()
    }
    
    private func prepareNavBar(_ editing: Bool) {
        setupNavBar()
    }
    
    private func prepareTabbar(_ editing: Bool) {
        extendedLayoutIncludesOpaqueBars = editing
        tabBarController?.tabBar.isHidden = editing
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()
    }
    
    private func prepareToolbar(_ editing: Bool) {
        if editing {
            if toolbar == nil {
                setupToolbar()
            }
        } else {
            toolbar?.removeFromSuperview()
            toolbar = nil
        }
    }
    
    private func preparePlus(_ editing: Bool) {
        plusButton.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.plusButton.alpha = editing ? 0 : 1
            self.plusButton.transform = editing ? .init(scaleX: 0.9, y: 0.9) : .identity
        }
        animator.addCompletion { position in
            if position == .end {
                self.plusButton.isHidden = editing
            }
        }
        animator.startAnimation()
    }
}
