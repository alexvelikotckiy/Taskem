//
//  AppEnvironmentPredicate.swift
//  Taskem
//
//  Created by Wilson on 07.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import PainlessInjection

struct AppEnvironmentPredicate: ModuleLoadingPredicate {
    let environments: [AppEnvironment]

    init(environments: [AppEnvironment]) {
        self.environments = environments
    }

    init(environment: AppEnvironment) {
        self.init(environments: [environment])
    }

    func shouldLoadModule() -> Bool {
        return environments.contains(AppEnvironment.current)
    }
}
