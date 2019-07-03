//
//  DatePickerManualRouter.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import PainlessInjection

public protocol DatePickerManualRouter {
    func dismiss(_ completion: @escaping (() -> Void))
}
