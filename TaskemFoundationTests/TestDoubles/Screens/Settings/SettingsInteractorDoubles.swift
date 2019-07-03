//
//  SettingsInteractorDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SettingsInteractorMock: SettingsInteractor {
    var delegate: SettingsInteractorOutput?
    
    var currentUser: User?
    var defaultGroup: Group?
    
    init() {
        self.currentUser = UserSourceStub.realUserStub()
        self.defaultGroup = GroupSourceMock.inboxDefaultGroup
    }
    
    func start() {
        
    }
    
    func didUpdateUser(_ user: User?) {
        
    }
    
    func sourceDidChangeState(_ source: GroupSource) {
        
    }
    
    func source(_ source: GroupSource, didAdd groups: [Group]) {
        
    }
    
    func source(_ source: GroupSource, didUpdate groups: [Group]) {
        
    }
    
    func source(_ source: GroupSource, didRemove ids: [EntityId]) {
        
    }
    
    func source(_ source: GroupSource, didUpdateOrderSequence ids: [EntityId]) {
        
    }
}

class SettingsInteractorSpy: SettingsInteractorMock {
    var didStartCall = false
    
    override func start() {
        super.start()
        
        didStartCall = true
    }
}

class SettingsInteractorObserverSpy: SettingsInteractorOutput {
    var didDidUpdateSettingsCall = false
    
    func settingsInteractorDidUpdateSettings() {
        didDidUpdateSettingsCall = true
    }
}
