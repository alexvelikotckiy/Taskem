//
//  SignUpViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SignUpViewSpy: SignUpView {
    var postNameFailureCount: Int = 0
    var postEmailFailureCount: Int = 0
    var postPasswordFailureCount: Int = 0
    
    var lastPostNameFailure: String?
    var lastPostEmailFailure: String?
    var lastPostPasswordFailure: String?
    var lastDisplayedViewModel: SignUpViewModel?
    var isVisibleSpinner: Bool?
    
    var delegate: SignUpViewDelegate? = nil
    
    func display(_ viewModel: SignUpViewModel) {
        lastDisplayedViewModel = viewModel
    }
    
    func displaySpinner(_ isVisible: Bool) {
        isVisibleSpinner = isVisible
    }
    
    func postNameFailure(_ description: String) {
        lastPostNameFailure = description
        postNameFailureCount += 1
    }
    
    func postEmailFailure(_ description: String) {
        lastPostEmailFailure = description
        postEmailFailureCount += 1
    }
    
    func postPasswordFailure(_ description: String) {
        lastPostPasswordFailure = description
        postPasswordFailureCount += 1
    }
}
