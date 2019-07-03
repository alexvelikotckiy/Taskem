//
//  SystemAppConfiguration.swift
//  Taskem
//
//  Created by Wilson on 4/7/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

public class SystemAppConfiguration: ApplicationConfiguration {
    public var ourWebsiteURL: URL { return URL(string: "")! }
    public var helpEmail: String { return "" }
    public var suggestionEmail: String { return "" }
    public var itunesConnectApplicationId: String { return "" }
    public var rateUsURL: URL { return URL(string: "")! }
    public var appURL: URL { return URL(string: "")! }
}
