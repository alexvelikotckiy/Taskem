//
//  UserTemplatesSetupRouterSpy.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class UserTemplatesSetupRouterSpy: UserTemplatesSetupRouter {
    var didDismissCall = false
    
    func dismiss() {
        didDismissCall = true
    }
}
