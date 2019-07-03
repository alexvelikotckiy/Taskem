//
//  MGSwipeView.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 5/4/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

open class MGSwipeView: UIView {
    
    public var swipeDirections = SwipeDirection.allDirections
    
    public var activeDirection: SwipeDirection? {
        return swipeDirections.reduce((highestPercentage: 0, direction: nil), { (percentage, direction) -> (CGFloat, SwipeDirection?) in
            let swipePercent = swipePercentage(on: direction)
            if swipePercent > percentage.highestPercentage {
                return (swipePercent, direction)
            }
            return percentage
        }).direction
    }
    
    public private(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    public private(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    //MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        initializeGestureRecognizers()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeGestureRecognizers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeGestureRecognizers()
    }
    
    private func initializeGestureRecognizers() {
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - Getters/Setters
    
    public func swipeSpeed(on direction: SwipeDirection) -> CGFloat {
        let velocity = panGestureRecognizer.velocity(in: superview)
        return abs(direction.point.dotProduct(with: velocity))
    }
    
    public func swipePercentage(on direction: SwipeDirection) -> CGFloat {
        let translation = panGestureRecognizer.translation(in: superview)
        let normalizedTranslation = translation.normalizedDistance(forSize: UIScreen.main.bounds.size)
        let percentage = normalizedTranslation.dotProduct(with: direction.point)
        if percentage < 0 {
            return 0
        }
        return percentage
    }
    
    //MARK: - Swipe/Tap Handling
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        didTap(on: self, recognizer: recognizer)
    }
    
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            beginSwiping(on: self, recognizer: recognizer)
        case .changed:
            continueSwiping(on: self, recognizer: recognizer)
        case .ended:
            endSwiping(on: self, recognizer: recognizer)
        default:
            break
        }
    }
    
    open func didTap(on view: MGSwipeView, recognizer: UITapGestureRecognizer) {}
    
    open func beginSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {}
    
    open func continueSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {}
    
    open func endSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {}
    
}
