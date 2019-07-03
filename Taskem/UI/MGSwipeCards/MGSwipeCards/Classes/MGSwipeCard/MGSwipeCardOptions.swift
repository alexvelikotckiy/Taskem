//
//  MGSwipeCardOptions.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 7/12/18.
//

import Foundation

open class MGSwipeCardOptions {
    
    public static var defaultOptions = MGSwipeCardOptions()

    ///The minimum required speed on the intended direction to trigger a swipe. Expressed in points per second. Defaults to 1600.
    open var minimumSwipeSpeed: CGFloat = 1600
    
    ///The minimum required drag distance on the intended direction to trigger a swipe. Measured from the initial touch point. Defined as a value in the range [0, 2]. Defaults to 0.5.
    open var minimumSwipeMargin: CGFloat = 0.5
    
    ///The maximum rotation angle of the card. Measured in radians. Defined as a value in the range [0, `CGFloat.pi`/2]. Defaults to `CGFloat.pi`/10.
    open var maximumRotationAngle: CGFloat = CGFloat.pi / 10
    
    public init() {}
}

