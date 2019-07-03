//
//  TaskNotesView.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation

public protocol TaskNotesViewDelegate: class {
    func onViewWillAppear()
    func onViewWillDisappear()
    
    func onUpdate(notes: String)
}

public protocol TaskNotesView: class {
    var delegate: TaskNotesViewDelegate? { get set }
    var viewModel: TaskNotesViewModel { get set }

    func display(viewModel: TaskNotesViewModel)
}
