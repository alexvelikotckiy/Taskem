//
//  SettingsInteractorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/15/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SettingsInteractorTestCase: TaskemTestCaseBase {

    fileprivate var interactor: SettingsDefaultInteractor!
    fileprivate var interactorSpy: SettingsInteractorObserverSpy!
    
    override func setUp() {
        super.setUp()
        
        interactor = .init(userService: UserSourceDummy(), groupSource: GroupSourceDummy())
        interactorSpy = .init()
        interactor.delegate = interactorSpy
    }
    
    func testShouldNotifyOnUpdateUser() {
        interactor.didUpdateUser(nil)
        
        expectNofityUpdateSettings()
    }
    
    func testShouldNotifyOnChangeGroupSourceState() {
        let source = GroupSourceDummy()
        source.state = .loaded
        
        interactor.sourceDidChangeState(source)
        
        expectNofityUpdateSettings()
    }
    
    func testShouldNotifyOnUpdateGroups() {
        let source = GroupSourceDummy()
        let group = GroupSourceMock.inboxDefaultGroup
        source.allGroups = [group]
        
        interactor.source(source, didUpdate: [group])
        
        expectNofityUpdateSettings()
    }
    
    private func expectNofityUpdateSettings() {
        expect(self.interactorSpy.didDidUpdateSettingsCall) == true
    }
}
