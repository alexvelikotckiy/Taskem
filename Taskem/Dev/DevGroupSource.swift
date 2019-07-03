//
//  DevTasksSource.swift
//  Taskem
//
//  Created by Wilson on 28.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class DevGroupSource: InMemoryGroupSource {
    private var isSetup = false
    private var notifyObservers = true
    
    override func start() {
        super.start()
        
        if !isSetup {
            notifyObservers = false
            setupFromManual()
            state = .loaded
            notifyObservers = true
            isSetup = true
        }
    }

    private func setupFromManual() {
        self.addTestGroups()
    }

    private func addTestGroups() {
        add(groups: SystemDevDataSource().devGroups())
    }

    public override func notifyAdd(groups: [Group]) {
        if notifyObservers {
            super.notifyAdd(groups: groups)
        }
    }

}
