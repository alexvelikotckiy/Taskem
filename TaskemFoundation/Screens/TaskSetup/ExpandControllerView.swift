//
//  ExpandControllerView.swift
//  Taskem
//
//  Created by Wilson on 04.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol TaskControllerViewDelegate: class {
    var model: TaskSetupViewModel { get }
    func updateTaskModel(_ taskViewModel: TaskSetupViewModel)
}

public protocol TaskControllerView: class {
    var viewDelegate: TaskControllerViewDelegate { get }
    func saveChanges()
}
