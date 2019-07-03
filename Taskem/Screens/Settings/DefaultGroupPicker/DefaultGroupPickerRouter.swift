//
//  DefaultGroupPickerRouter.swift
//  Taskem
//
//  Created by Wilson on 7/27/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class DefaultGroupPickerStandardRouter: DefaultGroupPickerRouter {
    weak var controller: DefaultGroupPickerViewController!
    
    init(defaultgrouppickerController: DefaultGroupPickerViewController) {
        self.controller = defaultgrouppickerController
    }
}
