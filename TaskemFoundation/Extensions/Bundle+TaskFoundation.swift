//
//  Bundle+TaskFoundation.swift
//  TaskemFoundation
//
//  Created by Wilson on 07.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension Bundle {
    public static var taskemFoundation: Bundle {
        if let bundle = Bundle(identifier: "com.wilson.taskemFoundation") {
            return bundle
        } else {
            fatalError("Cound not find bundle for com.wilson.taskemFoundation")
        }
    }
}
