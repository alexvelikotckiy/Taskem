//
//  NotificationSoundPickerInteractor.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol NotificationSoundPickerInteractorOutput: class {

}

public protocol NotificationSoundPickerInteractor: class {
    var delegate: NotificationSoundPickerInteractorOutput? { get set }
    
    func allSound() -> [ReminderSound]
    func selectAndPlay(_ sound: ReminderSound)
}

public class NotificationSoundPickerDefaultInteractor: NotificationSoundPickerInteractor {

    private let remindScheduler: RemindScheduleManager
    private let soundSource: ReminderSoundSource
    private let mediaPlayer: MediaPlayer
    
    public weak var delegate: NotificationSoundPickerInteractorOutput?

    public init(soundSource: ReminderSoundSource,
                mediaPlayer: MediaPlayer,
                remindScheduler: RemindScheduleManager) {
        self.soundSource = soundSource
        self.mediaPlayer = mediaPlayer
        self.remindScheduler = remindScheduler
    }

    public func selectAndPlay(_ sound: ReminderSound) {
        remindScheduler.changeSound(for: sound.name.lowercased())
        mediaPlayer.play(
            .init(fileName: sound.fileName,
                  fileExtension: "m4a")
        )
    }
    
    public func allSound() -> [ReminderSound] {
        return soundSource.allSounds()
    }
}
