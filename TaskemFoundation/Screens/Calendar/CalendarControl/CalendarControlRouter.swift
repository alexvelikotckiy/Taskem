//
//  CalendarControlRouter.swift
//  Taskem
//
//  Created by Wilson on 10/04/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol CalendarControlRouter {
    func dismiss()
    func alert(title: String, message: String, _ completion: @escaping ((Bool) -> Void))
}
