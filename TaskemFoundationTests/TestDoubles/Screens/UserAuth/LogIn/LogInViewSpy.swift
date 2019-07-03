//
//  LogInViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class LogInViewSpy: LogInView {
    var lastDisplayedViewModel: LogInViewModel?
    var isVisibleSpinner: Bool?
    
    var delegate: LogInViewDelegate? = nil
    
    func display(_ viewModel: LogInViewModel) {
        lastDisplayedViewModel = viewModel
    }
    
    func displaySpinner(_ isVisible: Bool) {
        isVisibleSpinner = isVisible
    }
    
    var didDisplayViewModel: Bool {
        return lastDisplayedViewModel != nil
    }
}
