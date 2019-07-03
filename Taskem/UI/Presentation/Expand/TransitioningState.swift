//
//  ExpandTransitioningState.swift
//  ExpandTest
//
//  Created by Wilson on 28.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

enum TransitioningState {
    case none
    case start
    case finish
    case update(currentPercentage: CGFloat)
    case cancel(lastPercentage: CGFloat)
}
