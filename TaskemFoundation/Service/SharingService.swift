//
//  SharingService.swift
//  TaskemFoundation
//
//  Created by Wilson on 13.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol SharingService: class {
    func share(text: String)
}

public extension SharingService {
    func createShareText(from tasks: [Task]) -> String? {
        guard !tasks.isEmpty else { return nil }
        var resultString = "Taskem Todo:\n"
        tasks.forEach { resultString.append("- \($0.name)\n") }
        return resultString
    }
}
