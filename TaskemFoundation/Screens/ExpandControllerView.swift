//
//  ExpandControllerView.swift
//  Taskem
//
//  Created by Wilson on 04.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ExpandControllerViewDelegate: class {
    associatedtype T
    
    var viewModel: T { get set }
    func update(_ viewModel: T)
}

public protocol ExpandControllerView: class {
    associatedtype T: ExpandControllerViewDelegate
    
    var viewDelegate: T { get }
    func saveChanges()
}
