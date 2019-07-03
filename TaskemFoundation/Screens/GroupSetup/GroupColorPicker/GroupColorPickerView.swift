//
//  GroupColorPickerView.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupColorPickerViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDisappear()
    
    func onSelect(at indexPath: IndexPath)
}

public protocol GroupColorPickerView: class {
    var delegate: GroupColorPickerViewDelegate? { get set }
    var viewModel: GroupColorPickerListViewModel { get set }

    func display(viewModel: GroupColorPickerListViewModel)
    func reload(at indexPath: IndexPath)
    func scroll(to indexPath: IndexPath)
}
