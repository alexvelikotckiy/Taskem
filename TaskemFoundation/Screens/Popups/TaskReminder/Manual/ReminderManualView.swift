//
//  ReminderManualView.swift
//  Taskem
//
//  Created by Wilson on 09/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderManualViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDismiss()
    
    func onChangeTime(date: Date)
    func onTouchSave()
}

public protocol ReminderManualView: class {
    var delegate: ReminderManualViewDelegate? { get set }
    var viewModel: ReminderManualListViewModel { get set }

    func display(_ viewModel: ReminderManualListViewModel)
    func reload(at index: IndexPath)
}
