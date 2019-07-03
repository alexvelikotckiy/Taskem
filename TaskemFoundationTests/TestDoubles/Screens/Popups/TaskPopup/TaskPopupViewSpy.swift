//
//  TaskPopupViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 11/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskPopupViewSpy: TaskPopupView {
    var delegate: TaskPopupViewDelegate?
    
    var viewModel: TaskPopupViewModel = .init()
    
    var displayViewModelCount = 0
    var reloadCount = 0
    
    func display(_ viewModel: TaskPopupViewModel) {
        self.viewModel = viewModel
        displayViewModelCount += 1
    }
    
    func reload() {
        reloadCount += 1
    }
}
