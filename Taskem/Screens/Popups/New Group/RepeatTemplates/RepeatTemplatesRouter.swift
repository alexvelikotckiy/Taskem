//
//  RepeatTemplatesStandardRouter.swift
//  Taskem
//
//  Created by Wilson on 11.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class RepeatTemplatesStandardRouter: RepeatTemplatesRouter {
    weak var controller: RepeatTemplatesViewController!

    init(repeattemplatesController: RepeatTemplatesViewController) {
        self.controller = repeattemplatesController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }

    func presentManual(data: RepeatManualPresenter.InitialData, callback: @escaping TaskRepeatCallback) {
        let vc: RepeatManualViewController = Container.get(data: data, callback: callback)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
}
