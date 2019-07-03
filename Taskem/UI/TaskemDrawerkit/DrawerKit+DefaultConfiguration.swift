//
//  DrawerKit+DefaultConfiguration.swift
//  Taskem
//
//  Created by Wilson on 8/10/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension DrawerConfiguration {
    
    static func defaultConfiguration() -> DrawerConfiguration {
        var configuration = DrawerConfiguration(/* ..., ..., ..., */)
        
        // ... or after initialisation. All of these have default values so change only
        // what you need to configure differently. They're all listed here just so you
        // can see what can be configured. The values listed are the default ones,
        // except where indicated otherwise.
        configuration.totalDurationInSeconds = 0.4
        configuration.durationIsProportionalToDistanceTraveled = true
        // default is UISpringTimingParametezrs()
        //        configuration.timingCurveProvider = UISpringTimingParameters(dampingRatio: 0.8)
        configuration.fullExpansionBehaviour = .coversFullScreen
        configuration.supportsPartialExpansion = true
        configuration.dismissesInStages = true
        configuration.isDrawerDraggable = true
        configuration.isFullyPresentableByDrawerTaps = false
        configuration.numberOfTapsForFullDrawerPresentation = 1
        configuration.isDismissableByOutsideDrawerTaps = true
        configuration.numberOfTapsForOutsideDrawerDismissal = 1
        configuration.flickSpeedThreshold = 3
        //        configuration.upperMarkGap = 100 // default is 40
        //        configuration.lowerMarkGap =  80 // default is 40
        configuration.maximumCornerRadius = 15
        
        var handleViewConfiguration = HandleViewConfiguration()
        handleViewConfiguration.autoAnimatesDimming = true
        handleViewConfiguration.backgroundColor = AppTheme.current.handleView
        handleViewConfiguration.size = .init(width: 100, height: 4)
        handleViewConfiguration.top = 8
        handleViewConfiguration.cornerRadius = .automatic
        configuration.handleViewConfiguration = handleViewConfiguration
        
        let borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let drawerBorderConfiguration = DrawerBorderConfiguration(borderThickness: 0.1,
                                                                  borderColor: borderColor)
        configuration.drawerBorderConfiguration = drawerBorderConfiguration // default is nil
        
        let drawerShadowConfiguration = DrawerShadowConfiguration(shadowOpacity: 0.75,
                                                                  shadowRadius: 10,
                                                                  shadowOffset: .zero,
                                                                  shadowColor: .black)
        configuration.drawerShadowConfiguration = drawerShadowConfiguration // default is nil
        
        return configuration
    }
}
