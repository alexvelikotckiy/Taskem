//
//  RepeatTemplatesRouter.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection

public protocol RepeatTemplatesRouter {
    func dismiss()
    
    func presentManual(data: RepeatManualPresenter.InitialData, callback: @escaping TaskRepeatCallback)
}
