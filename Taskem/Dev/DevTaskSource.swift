//
//  DevTaskSource.swift
//  Taskem
//
//  Created by Wilson on 29.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import TaskemFoundation

class DevTasksSource: InMemoryTaskSource {
    private var isSetup = false
    private var notifyObservers = true
    
    var groupsSource: GroupSource
    
    init(groupSource: GroupSource) {
        self.groupsSource = groupSource
        super.init()
    }

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
        addTestTasks()
    }

    private func addTestTasks() {
        add(tasks: SystemDevDataSource().devTasks(groupsSource.allGroups))
    }

    public override func notifyAdd(tasks: [Task]) {
        if notifyObservers {
            super.notifyAdd(tasks: tasks)
        }
    }

}
