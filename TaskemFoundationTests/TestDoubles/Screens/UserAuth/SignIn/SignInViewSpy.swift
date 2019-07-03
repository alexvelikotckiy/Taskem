//
//  SignInViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignInViewSpy: SignInView {
    var postEmailFailureCount: Int = 0
    var postPasswordFailureCount: Int = 0
    var postFailureCount: Int = 0

    var lastPostEmailFailure: String?
    var lastPostPasswordFailure: String?
    var lastPostFailure: String?
    var lastDisplayedViewModel: SignInViewModel?
    var isVisibleSpinner: Bool?
    
    var delegate: SignInViewDelegate? = nil
    
    func display(_ viewModel: SignInViewModel) {
        lastDisplayedViewModel = viewModel
    }
    
    func displaySpinner(_ isVisible: Bool) {
        isVisibleSpinner = isVisible
    }
    
    func postEmailFailure(_ description: String) {
        lastPostEmailFailure = description
        postEmailFailureCount += 1
    }
    
    func postPasswordFailure(_ description: String) {
        lastPostPasswordFailure = description
        postPasswordFailureCount += 1
    }
    
    func postFailure(_ description: String) {
        lastPostFailure = description
        postFailureCount += 1
    }
}
