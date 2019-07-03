//
//  Identifiable.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/14/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol Identifiable {
    var id: EntityId { get }
}
