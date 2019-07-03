//
//  DrawerTransitionInfo.swift
//  Taskem
//
//  Created by Wilson on 9/2/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public struct DrawerTransitionInfo {
    public var prevControllerConfiguration: DrawerConfiguration = .init()
    public var prevControllerState: DrawerState = .partiallyExpanded
    public var shouldResetConfigutaionOnDismiss = false
    
    public init() {
        
    }
    
    public init(prevControllerConfiguration: DrawerConfiguration,
                prevControllerState: DrawerState,
                shouldResetConfigutaionOnDismiss: Bool) {
        self.prevControllerConfiguration = prevControllerConfiguration
        self.prevControllerState = prevControllerState
        self.shouldResetConfigutaionOnDismiss = shouldResetConfigutaionOnDismiss
    }
}
