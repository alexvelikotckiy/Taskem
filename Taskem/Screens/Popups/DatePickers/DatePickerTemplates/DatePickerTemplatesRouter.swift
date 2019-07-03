//
//  DatePickerTemplatesRouter.swift
//  Taskem
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class DatePickerTemplatesStandardRouter: DatePickerTemplatesRouter {
    weak var controller: DatePickerTemplatesViewController!

    init(datepickertemplatesController: DatePickerTemplatesViewController) {
        self.controller = datepickertemplatesController
    }

    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func presentManual(_ initialData: DatePickerManualPresenter.InitialData, callback: @escaping DatePickerCallback) {
        let vc: DatePickerManualViewController = Container.get(data: initialData, callback: callback)
        controller.navigationController?.pushViewController(vc, animated: false)
    }
}
