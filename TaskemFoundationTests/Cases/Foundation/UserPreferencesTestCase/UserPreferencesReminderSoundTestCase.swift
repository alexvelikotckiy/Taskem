//
//  UserPreferencesReminderSoundTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 10/25/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class UserPreferencesReminderSoundTestCase: UserPreferencesTestCaseBase {
    
    private let reminderSoundKey = "\(UserPreferencesTestCaseBase.rootKey):reminderSound"
    
    func testShouldHaveDefaultValue() {
        expect(self.preferences.reminderSound) == SystemReminderSoundSource.defaultSound
    }
    
    func testShouldGetValue() {
        defaultsDouble.set("SOUND_STUB", forKey: reminderSoundKey)
        
        expect(self.preferences.reminderSound) == "SOUND_STUB"
    }
    
    func testShouldGetDefaultValueIfWrongFormat() {
        defaultsDouble.set(nil, forKey: reminderSoundKey)
        
        expect(self.preferences.reminderSound).to(equal(SystemReminderSoundSource.defaultSound))
    }
    
    func testShouldSaveValue() {
        self.preferences.reminderSound = "SOUND_STUB"
        
        expect(self.defaultsDouble.string(forKey: self.reminderSoundKey)).to(equal("SOUND_STUB"))
        expect(self.defaultsDouble.synchornizedWasCalled).to(beTrue())
    }
}
