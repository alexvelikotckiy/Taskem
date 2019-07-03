//
//  ApplicationConfiguration.swift
//  TaskemFoundation
//
//  Created by Wilson on 06.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ApplicationConfiguration: class {
    var ourWebsiteURL: URL { get }
    var helpEmail: String { get }
    var suggestionEmail: String { get }
    var itunesConnectApplicationId: String { get }
    var rateUsURL: URL { get }
    var appURL: URL { get }
}
