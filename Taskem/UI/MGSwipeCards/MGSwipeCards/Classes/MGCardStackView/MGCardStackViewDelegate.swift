//
//  MGSwipeableCardContainerDelegate.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 5/31/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Foundation

public protocol MGCardStackViewDelegate {
    
    func didSwipeAllCards(_ cardStack: MGCardStackView)
    func additionalOptions(_ cardStack: MGCardStackView) -> MGCardStackViewOptions
    func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection)
    func cardStack(_ cardStack: MGCardStackView, didUndoSwipeOnCardAt index: Int, from direction: SwipeDirection)
    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int)
    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int, tapCorner: UIRectCorner)
}

public extension MGCardStackViewDelegate {
    
    func didSwipeAllCards(_ cardStack: MGCardStackView) {}
    func additionalOptions(_ cardStack: MGCardStackView) -> MGCardStackViewOptions { return MGCardStackViewOptions.defaultOptions }
    func cardStack(_ cardStack: MGCardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection) {}
    func cardStack(_ cardStack: MGCardStackView, didUndoSwipeOnCardAt index: Int, from direction: SwipeDirection) {}
    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int) {}
    func cardStack(_ cardStack: MGCardStackView, didSelectCardAt index: Int, tapCorner: UIRectCorner) {}
}
