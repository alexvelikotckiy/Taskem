//
//  RescheduleView.swift
//  Taskem
//
//  Created by Wilson on 18/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol RescheduleViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDisappear()
    
    func onSwipe(at index: Int, direction: SwipeDirection)
    
    func onTouchUndoLast()
}

public protocol RescheduleView: class {
    var delegate: RescheduleViewDelegate? { get set }
    var viewModel: RescheduleListViewModel { get set }

    func display(_ viewModel: RescheduleListViewModel)
    func displayAllDone(_ visible: Bool)
    func displayNothingFound(_ visible: Bool)
    func displaySpinner(_ visible: Bool)
    
    func swipeCurrentCard(at direction: SwipeDirection)
    func undoLastSwipe()
}
