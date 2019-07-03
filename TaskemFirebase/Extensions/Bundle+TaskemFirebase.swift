//
//  Bundle+TaskemFirebase.swift
//  Taskem
//
//  Created by Wilson on 1/30/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

extension Bundle {
    public static var taskemFirebase: Bundle {
        if let bundle = Bundle(identifier: "com.wilson.taskemFirebase") {
            return bundle
        } else {
            fatalError("Cound not find bundle for com.wilson.taskemFirebase")
        }
    }
}
