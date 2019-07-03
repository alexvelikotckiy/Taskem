//
//  SharingServiceDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SharingServiceDummy: SharingService {
    func share(text: String) {
        
    }
}

class SharingServiceSpy: SharingService {
    func share(text: String) {
        lastSharedText = text
    }
    
    var lastSharedText: String?
}

