//
//  AppEnvironment.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

enum AppEnvironment {
    case dev
    case beta
    case prod
}

extension AppEnvironment {
    static var current: AppEnvironment {
        #if BUILD_DEVELOPMENT
            return .dev
        #elseif BUILD_BETA_TESTING
            return .beta
        #elseif BUILD_PRODUCTION
            return .prod
        #else
            fatalError("Unknown build configuration")
            UKNOWN_BUILD_CONFIGURATION_COMPILE_TIME_ERROR
        #endif
    }
}
