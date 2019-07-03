//
//  DataInitial.swift
//  TaskemFoundation
//
//  Created by Wilson on 12/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DataInitiable {
    associatedtype InitialData where InitialData: Equatable
    
    var initialData: InitialData { get }
}
