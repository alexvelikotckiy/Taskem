//
//  TaskPopupView.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol TaskPopupViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchCancel()
    func onTouchAdd()
    
    func onChangeName(text: String)
    
    func onTouchProject()
    func onTouchCalendar()
    func onTouchRepeat()
    func onTouchReminder()
    func onTouchRemoveTag(at index: Int)
}

public protocol TaskPopupView: class {
    var delegate: TaskPopupViewDelegate? { get set }
    var viewModel: TaskPopupViewModel { get set }

    func display(_ viewModel: TaskPopupViewModel)
    func reload()
}
