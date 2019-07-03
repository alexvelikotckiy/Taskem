//
//  Result.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}
