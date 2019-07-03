//
//  SchedulePreferencesSortConfigurationTestCases.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SchedulePreferencesSortConfigurationTestCase: SchedulePreferencesTestCaseBase {
    private let sortPreferenceKey = "\(SchedulePreferencesTestCaseBase.rootKey):sortPreference"

    func testShouldHaveDefaultValue() {
        expect(self.preferences.sortPreference) == .date
    }

    func testShouldGetValue() {
        defaultsDouble.set(1, forKey: sortPreferenceKey)

        expect(self.preferences.sortPreference) == .name
    }

    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set([123], forKey: sortPreferenceKey)

        expect(self.preferences.sortPreference) == .date
    }

    func testShouldSaveValue() {
        preferences.sortPreference = .name

        expect(self.preferences.sortPreference) == .name
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }

    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )

        preferences.sortPreference = .name

        expect(notificationWasPosted).to(beTrue(), description: "No notification")

        NotificationCenter.default.removeObserver(observer)
    }
}

class SchedulePreferencesTypeConfigurationTestCase: SchedulePreferencesTestCaseBase {
    private let typePreferencesKey = "\(SchedulePreferencesTestCaseBase.rootKey):typePreference"

    func testShouldHaveDefaultValue() {
        expect(self.preferences.typePreference) == .schedule
    }

    func testShouldGetValue() {
        defaultsDouble.set(2, forKey: typePreferencesKey)

        expect(self.preferences.typePreference) == .flat
    }

    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set(123, forKey: typePreferencesKey)

        expect(self.preferences.typePreference) == .schedule
    }

    func testShouldSaveValue() {
        preferences.typePreference = .flat

        expect(self.preferences.typePreference) == .flat
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }

    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )

        preferences.typePreference = .flat

        expect(notificationWasPosted).to(beTrue(), description: "No notification")

        NotificationCenter.default.removeObserver(observer)
    }
}

class SchedulePreferencesSelectedProjectsConfigurationTestCase: SchedulePreferencesTestCaseBase {
    private let selectedProjectsKey = "\(SchedulePreferencesTestCaseBase.rootKey):selectedProjects"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.selectedProjects) == .init()
    }

    func testShouldGetValue() {
        defaultsDouble.set(["group_id"], forKey: selectedProjectsKey)

        expect(self.preferences.selectedProjects) == ["group_id"]
    }

    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set([123], forKey: selectedProjectsKey)

        expect(self.preferences.selectedProjects) == []
    }

    func testShouldSaveValue() {
        preferences.selectedProjects = ["group_id"]

        expect(self.preferences.selectedProjects) == ["group_id"]
        expect(self.defaultsDouble.synchornizedWasCalled) == true
    }

    func testShouldNotifyChange() {
        var notificationWasPosted = false
        let observer = NotificationCenter.default.addObserver(
            forName: .ScheduleConfigurationDidChange,
            object: preferences,
            queue: nil,
            using: { _ in notificationWasPosted = true }
        )

        preferences.selectedProjects = ["group_id"]

        expect(notificationWasPosted).to(beTrue(), description: "No notification")

        NotificationCenter.default.removeObserver(observer)
    }
}
