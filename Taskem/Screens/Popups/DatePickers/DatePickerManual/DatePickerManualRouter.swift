//
//  DatePickerManualRouter.swift
//  Taskem
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class DatePickerManualStandardRouter: DatePickerManualRouter {
    weak var controller: DatePickerManualViewController!

    init(datepickermanualController: DatePickerManualViewController) {
        self.controller = datepickermanualController
    }

    func dismiss(_ completion: @escaping (() -> Void)) {
        self.controller.dismiss(animated: true, completion: completion)
    }

}
