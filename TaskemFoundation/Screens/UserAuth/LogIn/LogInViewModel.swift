//
//  LogInViewModel.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct LogInViewModel {
    public var anonymousSignInTitle: String
    
    public init() {
        self.anonymousSignInTitle = ""
    }
    
    public init(anonymousSignInTitle: String) {
        self.anonymousSignInTitle = anonymousSignInTitle
    }
}
