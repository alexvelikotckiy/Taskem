//
//  CompletedDataObserver.swift
//  TaskemFoundation
//
//  Created by Wilson on 9/2/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension CompletedPresenter: TableCoordinatorObserver {
    
    public func didBeginUpdate() {
        
    }
    
    public func didEndUpdate() {
        
    }
    
    public func didInsertRow(at index: IndexPath) {
        showAllDoneIfNeed()
    }
    
    public func didUpdateRow(at index: IndexPath) {
        showAllDoneIfNeed()
    }
    
    public func didDeleteRow(at index: IndexPath) {
        showAllDoneIfNeed()
    }
    
    public func didInsertSections(at indexes: IndexSet) {
        showAllDoneIfNeed()
    }
    
    public func didDeleteSections(at indexes: IndexSet) {
        showAllDoneIfNeed()
    }
    
    public func didMoveRow(from: IndexPath, to index: IndexPath) {
        showAllDoneIfNeed()
    }
    
    public func showAllDoneIfNeed() {
        view?.displayAllDone(view?.viewModel.sectionsCount() ?? 0 == 0)
    }
}
