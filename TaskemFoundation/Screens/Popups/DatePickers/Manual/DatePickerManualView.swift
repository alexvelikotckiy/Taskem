//
//  DatePickerManualView.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DatePickerManualViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDismiss()
    
    func onTouchChangePicker(_ picker: DatePickerManualViewModel.Screen)
    func onSelect(date: Date, on screen: DatePickerManualViewModel.Screen)
    func onSwitchTime(isAllDay: Bool)
    func onTouchSave()
}

public protocol DatePickerManualView: class {
    var delegate: DatePickerManualViewDelegate? { get set }
    var viewModel: DatePickerManualViewModel { get set}

    func display(_ viewModel: DatePickerManualViewModel)
    func scrollToDate(_ date: Date)
    func scrollToTime(_ date: Date)
}
