//
//  GroupPopupRouter.swift
//  Taskem
//
//  Created by Wilson on 24/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation
import PainlessInjection

class GroupPopupStandardRouter: GroupPopupRouter {
    weak var controller: GroupPopupViewController!

    init(grouppopupController: GroupPopupViewController) {
        self.controller = grouppopupController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentNewGroup(_ data: GroupOverviewPresenter.InitialData) {
        let vc: GroupOverviewViewController = Container.get(data)
        let navVc = UINavigationController(rootViewController: vc)
        controller.present(navVc, animated: true)
    }
}
