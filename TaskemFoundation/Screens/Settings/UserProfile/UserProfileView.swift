//
//  UserProfileView.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserProfileViewDelegate: class {
    func onViewWillAppear()
    func onSelect(at index: IndexPath)
}

public protocol UserProfileView: class {
    var delegate: UserProfileViewDelegate? { get set }
    var viewModel: UserProfileListViewModel { get set }

    func display(_ viewModel: UserProfileListViewModel)
    func displaySpinner(_ isVisible: Bool)
}
