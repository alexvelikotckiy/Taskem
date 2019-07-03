//
//  DevDashboardView.swift
//  Taskem
//
//  Created by Wilson on 12/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DevDashboardViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchResetUserData()
    func onTouchClearDefaults()
    func onTouchClearNotifications()
}

public protocol DevDashboardView: class {
    var delegate: DevDashboardViewDelegate? { get set }

    func display(_ viewModel: DevDashboardViewModel)
}
