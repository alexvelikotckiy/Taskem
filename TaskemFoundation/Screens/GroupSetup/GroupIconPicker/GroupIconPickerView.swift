//
//  GroupIconPickerView.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupIconPickerViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDisappear()
    
    func onSelect(at indexPath: IndexPath)
}

public protocol GroupIconPickerView: class {
    var delegate: GroupIconPickerViewDelegate? { get set }
    var viewModel: GroupIconPickerListViewModel { get set }

    func display(viewModel: GroupIconPickerListViewModel)
    func reload(at indexPath: IndexPath)
    func scroll(to indexPath: IndexPath)
}
