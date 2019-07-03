//
//  DevDashboardRouter.swift
//  Taskem
//
//  Created by Wilson on 7/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class DevDashboardStandardRouter: DevDashboardRouter {
    weak var controller: DevDashboardViewController!
    
    init(devdashboardController: DevDashboardViewController) {
        self.controller = devdashboardController
    }
}

