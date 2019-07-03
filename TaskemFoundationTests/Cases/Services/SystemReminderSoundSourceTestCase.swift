//
//  SystemReminderSoundSourceTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/30/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class SystemReminderSoundSourceTestCase: XCTestCase {

    private var source: SystemReminderSoundSource!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        source = .init()
    }
    
    func testShouldHaveSounds() {
        let sounds = source.allSounds()
        
        expect(sounds.count) == 12
        expect(sounds).to(contain(
            ReminderSound(name: "appointed".uppercased(),       fileName: "appointed"),
            ReminderSound(name: "arpeggio".uppercased(),        fileName: "arpeggio"),
            ReminderSound(name: "shoot'em".uppercased(),        fileName: "shoot-em"),
            ReminderSound(name: "light".uppercased(),           fileName: "light"),
            ReminderSound(name: "definite".uppercased(),        fileName: "definite"),
            ReminderSound(name: "unsure".uppercased(),          fileName: "unsure"),
            ReminderSound(name: "office".uppercased(),          fileName: "office"),
            ReminderSound(name: "consequence".uppercased(),     fileName: "consequence"),
            ReminderSound(name: "confident".uppercased(),       fileName: "confident"),
            ReminderSound(name: "quite impressed".uppercased(), fileName: "quite-impressed"),
            ReminderSound(name: "open ended".uppercased(),      fileName: "open-ended"),
            ReminderSound(name: "to the point".uppercased(),    fileName: "to-the-point")
        ))
    }
    
    func testShouldHaveDefaultSound() {
        expect(SystemReminderSoundSource.defaultSound) == "appointed"
    }
    
    func testShouldBeReminderSoundSource() {
        expect(self.source).to(beAKindOf(ReminderSoundSource.self))
    }
}
