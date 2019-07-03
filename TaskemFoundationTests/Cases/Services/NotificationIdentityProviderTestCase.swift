//
//  NotificationidentityProviderTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class NotificationIdentityProviderTestCase: XCTestCase {

    private var provider: SystemNotificationIdentityProvider!
    
    private let bundleIdentifier = "com.wilson.taskemFoundationTests"
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        provider = SystemNotificationIdentityProvider(bundleIdentifier: bundleIdentifier)
    }
    
    func testReminderBase() {
        expect(self.provider.reminderBase) == bundleIdentifier
    }
    
    func testProduceCategoryNotificationId() {
        let category = NotificationCategory.task
        
        expect(self.provider.produceCategoryNotificationId(category)) == "\(bundleIdentifier).\(category.rawValue)"
        expect(self.provider.produceCategoryNotificationId(category.rawValue)) == "\(bundleIdentifier).\(category.rawValue)"
    }
    
    func testProduceNotificationId() {
        let entityId: EntityId = .auto()
        let reminderId: EntityId = .auto()
        let reminderDate = Date.now
        let category = NotificationCategory.task
        
        let notificationId = provider.produceNotificationId(category: category, entityId: entityId, reminderId: reminderId, date: reminderDate)
        
        expect(notificationId) == "\(bundleIdentifier).\(category.rawValue).entity(\(entityId)).reminder(\(reminderId)).date(\(String(describing: reminderDate)))"
    }
    
    func testResolveId() {
        expect(self.provider.caregoryId(from: "\(self.bundleIdentifier).task")) == "task"
        expect(self.provider.caregoryId(from: "\(self.bundleIdentifier).task.123ABC")) == "task"
        expect(self.provider.caregoryId(from: "\(self.bundleIdentifier)123ABC.task.123ABC")).to(beNil())
        expect(self.provider.entityId(from: "bundleIdentifier.category.entity(ID).reminder(reminderId)")) == "ID"
        expect(self.provider.entityId(from: "bundleIdentifier.category.entity123(ID).reminder(reminderId)")).to(beNil())
    }
    
}
