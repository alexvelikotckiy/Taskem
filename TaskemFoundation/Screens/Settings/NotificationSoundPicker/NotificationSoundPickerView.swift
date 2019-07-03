//
//  NotificationSoundPickerView.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol NotificationSoundPickerViewDelegate: class {
    func onViewWillAppear()
    
    func onSelect(at index: IndexPath)
}

public protocol NotificationSoundPickerView: class {
    var delegate: NotificationSoundPickerViewDelegate? { get set }
    var viewModel: NotificationSoundPickerListViewModel { get set }

    func display(_ viewModel: NotificationSoundPickerListViewModel)
    func reload(at index: IndexPath)
}
