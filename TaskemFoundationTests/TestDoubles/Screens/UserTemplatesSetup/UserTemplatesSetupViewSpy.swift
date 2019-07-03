//
//  UserTemplatesSetupViewSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class UserTemplatesSetupViewSpy: UserTemplatesSetupView {
    var didDisplayViewModel = false
    
    var delegate: UserTemplatesSetupViewDelegate? = nil
    var viewModel: UserTemplatesSetupListViewModel = .init()
    
    func display(_ viewModel: UserTemplatesSetupListViewModel) {
        self.viewModel = viewModel
        didDisplayViewModel = true
    }
}
