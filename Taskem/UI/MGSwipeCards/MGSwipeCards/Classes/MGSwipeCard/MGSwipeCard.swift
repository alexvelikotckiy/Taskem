//
//  MGSwipeCard.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 5/4/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

public protocol MGSwipeCardDelegate {

    func card(didTap card: MGSwipeCard)
    func card(didBeginSwipe card: MGSwipeCard)
    func card(didContinueSwipe card: MGSwipeCard)
    func card(didSwipe card: MGSwipeCard, with direction: SwipeDirection)
    func card(didCancelSwipe card: MGSwipeCard)
}

open class MGSwipeCard: MGSwipeView {
    
    public var delegate: MGSwipeCardDelegate?
    
    open var options = MGSwipeCardOptions.defaultOptions
    
    public var touchPoint: CGPoint?
    
    public private(set) var contentView: UIView?
    public private(set) var footerView: UIView?
    private var overlayContainer: UIView?
    private var overlays: [SwipeDirection: UIView?] = [:]
    
    public var footerIsTransparent = false {
        didSet { setNeedsLayout() }
    }
    
    public var footerHeight: CGFloat = 100 {
        didSet { setNeedsLayout() }
    }
    
    private var contentViewConstraints: [NSLayoutConstraint] = []
    private var footerViewConstraints: [NSLayoutConstraint] = []
    private var overlayContainerConstraints: [NSLayoutConstraint] = []
    
    //MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutFooterView()
        layoutContentView()
        layoutOverlays()
        updateViewHierarchy()
    }
    
    private func layoutContentView() {
        guard let content = contentView else { return }
        NSLayoutConstraint.deactivate(contentViewConstraints)
        if footerView == nil || footerIsTransparent {
            contentViewConstraints = content.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        } else {
            contentViewConstraints = content.anchor(top: topAnchor, left: leftAnchor, bottom: footerView!.topAnchor, right: rightAnchor)
        }
    }
    
    private func layoutFooterView() {
        guard let footer = footerView else { return }
        NSLayoutConstraint.deactivate(footerViewConstraints)
        footerViewConstraints = footer.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, heightConstant: footerHeight)
    }
    
    private func layoutOverlays() {
        guard let overlayContainer = overlayContainer else { return }
        NSLayoutConstraint.deactivate(overlayContainerConstraints)
        if footerView == nil {
            overlayContainerConstraints = overlayContainer.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        } else {
            overlayContainerConstraints = overlayContainer.anchor(top: topAnchor, left: leftAnchor, bottom: footerView!.topAnchor, right: rightAnchor)
        }
    }
    
    private func updateViewHierarchy() {
        if contentView != nil {
            sendSubviewToBack(contentView!)
        }
        if overlayContainer != nil {
            bringSubviewToFront(overlayContainer!)
        }
    }
    
    //MARK: - Setters/Getters
    
    public func setContentView(_ content: UIView?) {
        guard let content = content else { return }
        contentView = content
        addSubview(contentView!)
        setNeedsLayout()
    }
    
    public func setFooterView(_ footer: UIView?) {
        guard let footer = footer else { return }
        footerView = footer
        addSubview(footerView!)
        setNeedsLayout()
    }
    
    public func setOverlay(forDirection direction: SwipeDirection, overlay: UIView?) {
        guard let overlay = overlay else { return }
        if overlayContainer == nil {
            overlayContainer = UIView()
            addSubview(overlayContainer!)
        }
        overlays[direction]??.removeFromSuperview()
        overlays[direction] = overlay
        overlays[direction]??.alpha = 0
        overlayContainer?.addSubview(overlay)
        let _ : [NSLayoutConstraint] = overlay.anchor(top: overlayContainer?.topAnchor, left: overlayContainer?.leftAnchor, bottom: overlayContainer?.bottomAnchor, right: overlayContainer?.rightAnchor)
        setNeedsLayout()
    }
    
    public func overlay(forDirection direction: SwipeDirection) -> UIView? {
        return overlays[direction] ?? nil
    }

    //MARK: - Gesture Handling
    
    private var rotationDirectionY: CGFloat = 1
    
    open override func didTap(on view: MGSwipeView, recognizer: UITapGestureRecognizer) {
        delegate?.card(didTap: self)
    }
    
    open override func beginSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        let touchPoint = recognizer.location(in: self)
        if touchPoint.y < bounds.height / 2 {
            rotationDirectionY = 1
        } else {
            rotationDirectionY = -1
        }
        self.touchPoint = touchPoint
        delegate?.card(didBeginSwipe: self)
    }
    
    open override func continueSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        var transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        let superviewTranslation = recognizer.translation(in: superview)
        let rotationStrength = min(superviewTranslation.x / UIScreen.main.bounds.width, 1)
        let rotationAngle = max(-CGFloat.pi/2, min(rotationDirectionY * abs(options.maximumRotationAngle) * rotationStrength, CGFloat.pi/2))
        transform = transform.concatenating(CGAffineTransform(rotationAngle: rotationAngle))
        layer.setAffineTransform(transform)
        delegate?.card(didContinueSwipe: self)
    }
    
    open override func endSwiping(on view: MGSwipeView, recognizer: UIPanGestureRecognizer) {
        layer.shouldRasterize = false
        if let direction = activeDirection {
            if swipeSpeed(on: direction) >= options.minimumSwipeSpeed {
                delegate?.card(didSwipe: self, with: direction)
            } else if swipePercentage(on: direction) >= options.minimumSwipeMargin {
                delegate?.card(didSwipe: self, with: direction)
            } else {
                delegate?.card(didCancelSwipe: self)
            }
        } else {
            delegate?.card(didCancelSwipe: self)
        }
    }
    
}
