//
//  ScheduleView.swift
//  Taskem
//
//  Created by Wilson on 11/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import Foundation

public protocol ScheduleViewDelegate: class {
    func onViewWillAppear()

    // a nav bar delegate
    func onRefresh()
    func onTouchScheduleControl()
    func onChangeSorting(_ sorting: ScheduleTableType)
    func onTouchThreeDots()
    
    // searching
    func onSearch(_ text: String)
    func onBeginSearch()
    func onEndSearch()
    
    // a plus button action
    func onTouchPlus(isLongTap: Bool)
    
    // a cell selection
    func onTouch(at indexPath: IndexPath, frame: CGRect)
    
    // cell swipes
    func onSwipeLeft(at indexes: [IndexPath], _ completion: @escaping (Bool) -> Void)
    func onSwipeRight(at indexes: [IndexPath])
    
    // table header actions
    func onTouchToogleHeader(with type: ScheduleSectionType)
    func onTouchHeaderAction(with type: ScheduleSectionType)
    
    // reordering
    func onReorderingWillBegin(initial: IndexPath)
    func onReorderingDidEnd(source: IndexPath, destination: IndexPath)
    
    // editing
    func onBeginEditing()
    func onEndEditing()
    
    func onEditDelete(at indexes: [IndexPath])
    func onEditGroup(at indexes: [IndexPath])
    func onShare(at indexes: [IndexPath])
}

public protocol ScheduleView: TableCoordinatorDelegate {
    var delegate: ScheduleViewDelegate? { get set }

    var viewModel: ScheduleListViewModel { get set }
    func display(viewModel: ScheduleListViewModel)
    func display(title: String)
    
    func displayAllDone(_ isVisible: Bool)
    func displaySpinner(_ isVisible: Bool)
    func displayNotFound(_ isVisible: Bool)
    
    func displayHeader(model: ScheduleSectionViewModel, at index: Int)
}
