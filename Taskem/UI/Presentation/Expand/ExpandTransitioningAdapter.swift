//
//  ExpandTransitioningAdapter.swift
//  ExpandTest
//
//  Created by Wilson on 28.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

protocol ExpandTransitioningAdapter: class {
    func shouldBeginExpandInteractiveTransitioning() -> Bool
    
    func willBeginInteractiveTransitioning()
    func didEndInteractiveTransitioning()
}
