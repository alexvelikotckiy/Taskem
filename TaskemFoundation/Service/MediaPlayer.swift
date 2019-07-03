//
//  MediaPlayer.swift
//  TaskemFoundation
//
//  Created by Wilson on 4/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct MediaFile {
    public let fileName: String
    public let fileExtension: String
}

public protocol MediaPlayer: class {
    func play(_ file: MediaFile)
}
