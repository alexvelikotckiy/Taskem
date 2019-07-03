//
//  GroupOverviewView.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupOverviewViewDelegate: class {
    func onViewWillAppear()

    func onTouchDelete()
    func onTouchSave()
    func onTouchCancel()
    func onTouchCell(at indexPath: IndexPath)
    func onChangeName(text: String)
    func onChangeDefault(isOn: Bool)
    
    func onEditingStart()
    func onEditingEnd()
}

public protocol GroupOverviewView: class {
    var delegate: GroupOverviewViewDelegate? { get set }
    var viewModel: GroupOverviewListViewModel { get set }

    func display(viewModel: GroupOverviewListViewModel)
}
