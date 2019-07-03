//
//  SwipeDirection.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 5/4/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

public enum SwipeDirection: Int {
    
    case left, right, up, down
    
    public static var allDirections: [SwipeDirection] {
        return [.left, .right, .up, .down]
    }
    
    public var point: CGPoint {
        switch self {
        case .left:
            return CGPoint(x: -1, y: 0)
        case .right:
            return CGPoint(x: 1, y: 0)
        case .up:
            return CGPoint(x: 0, y: -1)
        case .down:
            return CGPoint(x: 0, y: 1)
        }
    }
    
}
