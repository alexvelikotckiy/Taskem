//
//  CalendarControlView.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarControlViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchDone()
    func onTouchToogleAll()
    func onSelect(at index: IndexPath)
    func onDeselect(at index: IndexPath)
}

public protocol CalendarControlView: class {
    var delegate: CalendarControlViewDelegate? { get set }
    var viewModel: CalendarControlListViewModel { get set }

    func display(viewModel: CalendarControlListViewModel)
    func resolveSelection(animated: Bool)
//    func reloadCell(at index: IndexPath)
//    func setSelected(at index: IndexPath, selected: Bool)
}
