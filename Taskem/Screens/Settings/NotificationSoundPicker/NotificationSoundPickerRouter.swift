//
//  NotificationSoundPickerRouter.swift
//  Taskem
//
//  Created by Wilson on 7/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class NotificationSoundPickerStandardRouter: NotificationSoundPickerRouter {
    weak var controller: NotificationSoundPickerViewController!
    
    init(notificationsoundpickerController: NotificationSoundPickerViewController) {
        self.controller = notificationsoundpickerController
    }
}

