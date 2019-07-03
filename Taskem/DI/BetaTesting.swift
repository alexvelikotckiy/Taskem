//
//  BetaTesting.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import PainlessInjection

class BetaTestingModule: Module {
    override func load() {
    }

    override func loadingPredicate() -> ModuleLoadingPredicate {
        return AppEnvironmentPredicate(environment: .beta)
    }
}
