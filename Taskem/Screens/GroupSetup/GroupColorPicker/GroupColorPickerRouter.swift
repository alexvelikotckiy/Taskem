//
//  GroupColorPickerRouter.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class GroupColorPickerStandardRouter: GroupColorPickerRouter {
    weak var controller: GroupColorPickerViewController!

    init(groupcolorpickerController: GroupColorPickerViewController) {
        self.controller = groupcolorpickerController
    }
}
