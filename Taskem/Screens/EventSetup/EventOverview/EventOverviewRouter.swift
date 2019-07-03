//
//  EventOverviewRouter.swift
//  Taskem
//
//  Created by Wilson on 7/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class EventOverviewStandardRouter: EventOverviewRouter {
    weak var controller: EventOverviewViewController!
    
    init(eventoverviewController: EventOverviewViewController) {
        self.controller = eventoverviewController
    }
}

