//
//  SystemReminderSoundSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class SystemReminderSoundSource: ReminderSoundSource {

    public static let defaultSound: String = "appointed"

    public init() {

    }

    public func allSounds() -> [ReminderSound] {
        return [
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
            ReminderSound(name: "to the point".uppercased(),    fileName: "to-the-point"),
        ]
    }
}
