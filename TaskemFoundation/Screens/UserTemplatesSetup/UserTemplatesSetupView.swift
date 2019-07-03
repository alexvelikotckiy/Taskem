//
//  UserTemplatesSetupView.swift
//  Taskem
//
//  Created by Wilson on 29/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol UserTemplatesSetupViewDelegate: class {
    func onViewWillAppear()
    func onSelectCell(at index: IndexPath)
    func onDeselectCell(at index: IndexPath)
    func onTouchContinue()
}

public protocol UserTemplatesSetupView: class {
    var delegate: UserTemplatesSetupViewDelegate? { get set }
    var viewModel: UserTemplatesSetupListViewModel { get set }

    func display(_ viewModel: UserTemplatesSetupListViewModel)
}
