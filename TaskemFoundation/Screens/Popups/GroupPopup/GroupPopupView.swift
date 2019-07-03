//
//  GroupPopupView.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation
public protocol GroupPopupViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchCancel()
    func onSelect(at index: IndexPath)
}

public protocol GroupPopupView: class {
    var delegate: GroupPopupViewDelegate? { get set }
    var viewModel: GroupPopupListViewModel { get set }

    func display(_ viewModel: GroupPopupListViewModel)
}
