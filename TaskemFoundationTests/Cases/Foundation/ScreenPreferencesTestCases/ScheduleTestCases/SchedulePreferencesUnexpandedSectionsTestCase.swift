//
//  SchedulePreferencesUnexpandedSectionsTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SchedulePreferencesUnexpandedScheduleSectionsTestCase: SchedulePreferencesTestCaseBase {
    private let scheduleUnexpandedKey = "\(SchedulePreferencesTestCaseBase.rootKey):scheduleUnexpanded"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.scheduleUnexpanded) == .init()
    }
    
    func testShouldGetValue() {
        defaultsDouble.set([0, 1, 2], forKey: scheduleUnexpandedKey)
        
        expect(self.preferences.scheduleUnexpanded) == [.overdue, .today, .tomorrow]
    }
    
    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set([100, "100"], forKey: scheduleUnexpandedKey)
        
        expect(self.preferences.scheduleUnexpanded) == []
    }
    
    func testShouldSaveValue() {
        preferences.scheduleUnexpanded = [.overdue]
        
        expect(self.preferences.scheduleUnexpanded) == [.overdue]
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleSectionsConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )
        
        preferences.scheduleUnexpanded = [.overdue]
        
        expect(notificationWasPosted).to(beTrue(), description: "No notification")
        
        NotificationCenter.default.removeObserver(observer)
    }
}

class SchedulePreferencesUnexpandedProjectSectionsTestCase: SchedulePreferencesTestCaseBase {
    private let projectsUnexpandedKey = "\(SchedulePreferencesTestCaseBase.rootKey):projectsUnexpanded"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.projectsUnexpanded) == .init()
    }
    
    func testShouldGetValue() {
        defaultsDouble.set(["group_id"], forKey: projectsUnexpandedKey)
        
        expect(self.preferences.projectsUnexpanded) == ["group_id"]
    }
    
    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set([123], forKey: projectsUnexpandedKey)
        
        expect(self.preferences.projectsUnexpanded) == []
    }
    
    func testShouldSaveValue() {
        preferences.projectsUnexpanded = ["group_id"]
        
        expect(self.preferences.projectsUnexpanded) == ["group_id"]
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleSectionsConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )
        
        preferences.projectsUnexpanded = ["group_id"]
        
        expect(notificationWasPosted).to(beTrue(), description: "No notification")
        
        NotificationCenter.default.removeObserver(observer)
    }
}

class SchedulePreferencesUnexpandedFlatSectionsTestCase: SchedulePreferencesTestCaseBase {
    private let flatUnexpandedKey = "\(SchedulePreferencesTestCaseBase.rootKey):flatUnexpanded"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.flatUnexpanded) == .init()
    }
    
    func testShouldGetValue() {
        defaultsDouble.set([0, 1], forKey: flatUnexpandedKey)
        
        expect(self.preferences.flatUnexpanded) == [.uncomplete, .complete]
    }
    
    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set([100, "100"], forKey: flatUnexpandedKey)
        
        expect(self.preferences.flatUnexpanded) == []
    }
    
    func testShouldSaveValue() {
        preferences.flatUnexpanded = [.uncomplete]
        
        expect(self.preferences.flatUnexpanded) == [.uncomplete]
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }
    
    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleSectionsConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )
        
        preferences.flatUnexpanded = [.uncomplete]
        
        expect(notificationWasPosted).to(beTrue(), description: "No notification")
        
        NotificationCenter.default.removeObserver(observer)
    }
}
