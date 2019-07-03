//
//  AppTheme.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public enum AppTheme: String {
    case light
    case dark
}

extension AppTheme: CustomStringConvertible {
    public var description: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

extension AppTheme {
    public static var current: AppTheme {
        return UserPreferences.current.theme
    }
}
