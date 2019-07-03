//
//  ThemeManager.swift
//  TaskemFoundation
//
//  Created by Wilson on 12/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ThemeObservable: class {
    func applyTheme(_ theme: AppTheme)
}

public protocol ThemeManager: class {
    var observers: ObserverCollection<ThemeObservable> { get set }
    
    func start()
    func stop()
}

public extension ThemeManager {
    var currentTheme: AppTheme {
        return UserPreferences.current.theme
    }
    
    func addObserver(_ observer: ThemeObservable) {
        observers.append(observer)
    }
    
    func addAndEmitObserver(_ observer: ThemeObservable) {
        observers.append(observer)
        observer.applyTheme(currentTheme)
    }
    
    func removeObserver(_ observer: ThemeObservable) {
        observers.remove(observer)
    }
    
    func notifyDidChangeTheme(_ theme: AppTheme) {
        observers.forEach { $0?.applyTheme(theme) }
    }
}
