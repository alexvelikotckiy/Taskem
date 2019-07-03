//
//  ReminderSoundSource.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ReminderSoundSource: class {
    func allSounds() -> [ReminderSound]
}
