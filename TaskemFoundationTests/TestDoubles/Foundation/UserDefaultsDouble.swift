//
//  UserDefaultsDouble.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class UserDefaultsDouble: UserDefaults {
    var synchornizedWasCalled: Bool = false
    
    override func synchronize() -> Bool {
        synchornizedWasCalled = true
        return super.synchronize()
    }
    
    func resetDefaults() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
        let old = synchornizedWasCalled
        _ = synchronize()
        synchornizedWasCalled = old
    }
}
