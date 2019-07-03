//
//  AVMediaPlayer.swift
//  Taskem
//
//  Created by Wilson on 4/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import AVFoundation
import TaskemFoundation

public class AVMediaPlayer: MediaPlayer {
    public init() {

    }

    public func play(_ file: MediaFile) {
        if let oldPlayer = player {
            oldPlayer.stop()
            player = nil
        }

        let bundle = Bundle.main
        if let url = bundle.url(forResource: file.fileName, withExtension: file.fileExtension),
            let newPlayer = try? AVAudioPlayer(contentsOf: url) {
            newPlayer.prepareToPlay()
            newPlayer.play()
            
            player = newPlayer
        }
    }

    private var player: AVAudioPlayer?
}
