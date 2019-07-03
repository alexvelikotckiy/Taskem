//
//  SettingsRouter.swift
//  Taskem
//
//  Created by Wilson on 7/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection
import TaskemFoundation

class SettingsStandardRouter: SettingsRouter {
    weak var controller: SettingsViewController!
    
    init(settingsController: SettingsViewController) {
        self.controller = settingsController
    }
    
    func presentUserProfile() {
        let vc: UserProfileViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentNotificationSoundPicker() {
        let vc: NotificationSoundPickerViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentLogIn() {
        let vc: LogInViewController = Container.get()
        let navVc = UINavigationController(rootViewController: vc)
        controller.navigationController?.present(navVc, animated: true, completion: nil)
    }
    
    func presentDefaultList() {
        let vc: DefaultGroupPickerViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentCompletedTasks() {
        let vc: CompletedViewController = Container.get()
        vc.hidesBottomBarWhenPushed = true
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentReschedule() {
        let vc: RescheduleViewController = Container.get()
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}
