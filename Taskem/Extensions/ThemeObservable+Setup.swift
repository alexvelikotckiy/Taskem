//
//  ThemeObservable+Setup.swift
//  Taskem
//
//  Created by Wilson on 12/12/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

extension ThemeObservable {
    func observeAppTheme() {
        let themeManager: ThemeManager = Container.get()
        themeManager.addAndEmitObserver(self)
    }
}
