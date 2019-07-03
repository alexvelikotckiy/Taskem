//
//  GroupIconPickerRouter.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class GroupIconPickerStandardRouter: GroupIconPickerRouter {
    weak var controller: GroupIconPickerViewController!

    init(groupiconpickerController: GroupIconPickerViewController) {
        self.controller = groupiconpickerController
    }
}
