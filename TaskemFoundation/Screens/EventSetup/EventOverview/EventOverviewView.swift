//
//  EventOverviewView.swift
//  Taskem
//
//  Created by Wilson on 18/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol EventOverviewViewDelegate: class {
    func onViewWillAppear()
}

public protocol EventOverviewView: class {
    var viewDelegate: EventOverviewViewDelegate? { get set }

    func display(_ viewModel: EventOverviewViewModel)
}
