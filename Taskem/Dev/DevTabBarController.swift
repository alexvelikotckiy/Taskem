//
//  DevTabBarController.swift
//  Taskem
//
//  Created by Wilson on 7/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection

class DevApplicationTabBarController: TapBarViewController {
    override func appTabBarControllers() -> [UIViewController] {
        var list = super.appTabBarControllers()
        
        let vc: DevDashboardViewController = Container.get()
        vc.tabBarItem = UITabBarItem(
            title: "Dev",
            image: Icons.icTabbarSettings.image,
            selectedImage: nil
        )
        list.append(vc)
        return list
    }
}
