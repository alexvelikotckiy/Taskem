//
//  RepeatManualStandardRouter.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class RepeatManualStandardRouter: RepeatManualRouter {
    weak var controller: RepeatManualViewController!

    init(repeatmanualController: RepeatManualViewController) {
        self.controller = repeatmanualController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
}
