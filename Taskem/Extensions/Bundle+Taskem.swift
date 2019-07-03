//
//  Bundle+Taskem.swift
//  Taskem
//
//  Created by Wilson on 3/7/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

extension Bundle {
    public static var taskem: Bundle {
        if let bundle = Bundle(identifier: "com.wilson.taskem") {
            return bundle
        } else {
            fatalError("Cound not find bundle for com.wilson.taskem")
        }
    }
}
