//
//  DefaultGroupPickerView.swift
//  Taskem
//
//  Created by Wilson on 27/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DefaultGroupPickerViewDelegate: class {
    func onViewWillAppear()
    
    func onSelect(at index: Int)
}

public protocol DefaultGroupPickerView: class {
    var delegate: DefaultGroupPickerViewDelegate? { get set }
    var viewModel: DefaultGroupPickerListViewModel { get set }

    func display(_ viewModel: DefaultGroupPickerListViewModel)
    func displaySpinner(_ isVisible: Bool)
    func reload(at index: Int)
}
