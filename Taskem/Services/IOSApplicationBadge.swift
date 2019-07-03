//
//  IOSApplicationBadge.swift
//  Taskem
//
//  Created by Wilson on 4/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

public class IOSApplicationBadge: ApplicationBadge {
    public var value: Int {
        get {
            return application.applicationIconBadgeNumber
        }
        set {
            application.applicationIconBadgeNumber = newValue
        }
    }

    public var application = UIApplication.shared
}
