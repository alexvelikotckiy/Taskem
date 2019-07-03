//
//  PasswordResetViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class PasswordResetViewSpy: PasswordResetView {
    var postEmailFailureCount: Int = 0
    var postFailureCount: Int = 0
    
    var lastPostEmailFailure: String?
    var lastPostFailure: String?
    var lastDisplayedViewModel: PasswordResetViewModel?
    var isVisibleSpinner: Bool?
    
    var delegate: PasswordResetViewDelegate?
    
    func display(_ viewModel: PasswordResetViewModel) {
        lastDisplayedViewModel = viewModel
    }
    
    func displaySpinner(_ isVisible: Bool) {
        isVisibleSpinner = isVisible
    }
    
    func postEmailFailure(_ description: String) {
        lastPostEmailFailure = description
        postEmailFailureCount += 1
    }
    
    func postFailure(_ description: String) {
        lastPostFailure = description
        postFailureCount += 1
    }
}
