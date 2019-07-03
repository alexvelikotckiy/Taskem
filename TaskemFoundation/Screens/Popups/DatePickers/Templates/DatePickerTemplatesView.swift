//
//  DatePickerTemplatesView.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DatePickerTemplatesViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDismiss()
    
    func onTouch(at index: IndexPath)
    func onLongTouch(at index: IndexPath)
}

public protocol DatePickerTemplatesView: class {
    var delegate: DatePickerTemplatesViewDelegate? { get set }
    var viewModel: DatePickerTemplatesListViewModel { get set }

    func display(_ viewModel: DatePickerTemplatesListViewModel)
}
