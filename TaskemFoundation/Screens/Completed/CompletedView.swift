//
//  CompletedView.swift
//  Taskem
//
//  Created by Wilson on 15/01/2018.
//  Copyright © 2018 WIlson. All rights reserved.
//

import UIKit
import Foundation

public protocol CompletedViewDelegate: class {
    func onViewWillAppear()
    func onTouchClearAll()
    
    func onTouchCell(at index: IndexPath, frame: CGRect)
    func onSwipeRight(at index: IndexPath)
    func onSwipeLeft(at index: IndexPath, _ completion: @escaping () -> Void)
    func onToogleCompletion(at index: IndexPath)
}

public protocol CompletedView: TableCoordinatorDelegate {
    var delegate: CompletedViewDelegate? { get set }
    var viewModel: CompletedListViewModel { get set }

    func display(_ viewModel: CompletedListViewModel)
    func displayAllDone(_ isVisible: Bool)
    
    func displayRefresh(_ isRefreshing: Bool)
}
