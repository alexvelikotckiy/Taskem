//
//  UserTemplatesSetupRouter.swift
//  Taskem
//
//  Created by Wilson on 6/29/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class UserTemplatesSetupStandardRouter: UserTemplatesSetupRouter {
    weak var controller: UserTemplatesSetupViewController!

    init(usertemplatessetupController: UserTemplatesSetupViewController) {
        self.controller = usertemplatessetupController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
}
