//
//  RepeatTemplatesView.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol RepeatTemplatesViewDelegate: class {
    func onViewWillAppear()
    
    func onTouchCell(at index: IndexPath)
    func onTouchBack()
}

public protocol RepeatTemplatesView: class {
    var delegate: RepeatTemplatesViewDelegate? { get set }
    var viewModel: RepeatTemplatesListViewModel { get set }

    func display(_ viewModel: RepeatTemplatesListViewModel)
}
