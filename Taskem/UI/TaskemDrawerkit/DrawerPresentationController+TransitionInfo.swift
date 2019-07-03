//
//  DrawerPresentationController+TransitionInfo.swift
//  Taskem
//
//  Created by Wilson on 9/2/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension DrawerPresentationControlling {
    public func resetTransitionInfo(_ info: DrawerTransitionInfo, animateTransition: (() -> Void)?) {
        animateTransition?()
        
        if info.shouldResetConfigutaionOnDismiss {
            configuration = info.prevControllerConfiguration
            self.animateTransition(to: info.prevControllerState, animateAlongside: nil, completion: nil)
        } 
    }
}
