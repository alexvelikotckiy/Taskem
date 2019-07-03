//
//  ReminderTemplatesView.swift
//  Taskem
//
//  Created by Wilson on 13/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderTemplatesViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchCell(at index: IndexPath)
    func onTouchBack()
}

public protocol ReminderTemplatesView: class {
    var delegate: ReminderTemplatesViewDelegate? { get set }
    var viewModel: ReminderTemplatesListViewModel { get set }

    func display(_ viewModel: ReminderTemplatesListViewModel)
}
