//
//  CardStackAnimator.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 7/13/18.
//

import Foundation
import pop

open class CardStackAnimator {

    public var isResettingCard: Bool = false
    
    private var cardStack: MGCardStackView
    
    init(cardStack: MGCardStackView) {
        self.cardStack = cardStack
    }
    
    //MARK: - Public
    
    open func applyScaleAnimation(to card: MGSwipeCard?, at index: Int, duration: TimeInterval, delay: TimeInterval = 0, completion: ((Bool) -> Void)?) {
        guard let card = card else { return }
        if index == 0 {
            applyScaleAnimation(to: card, scaleFactor: 1, beginTime: CACurrentMediaTime() + delay, duration: duration) { _, finished in
                completion?(finished)
            }
        } else {
            applyScaleAnimation(to: card, scaleFactor: cardStack.options.backgroundCardScaleFactor, duration: duration) { _, finished in
                completion?(finished)
            }
        }
    }
    
    open func applySwipeAnimation(to card: MGSwipeCard?, direction: SwipeDirection, forced: Bool = false, completion: ((Bool) -> Void)?) {
        guard let card = card else { return }
        removeAllAnimations(on: card)

        card.layer.shouldRasterize = true
        card.layer.rasterizationScale = UIScreen.main.scale
        
        let overlayDuration = forced ? cardStack.options.cardOverlayFadeInOutDuration : 0
        let rotation = forced ? randomRotationForSwipe(card, direction: direction) : rotationForSwipe(card, direction: direction)
        let dragTranslation = forced ? direction.point : card.panGestureRecognizer.translation(in: card.superview)
        let translation = translationPoint(card, direction: direction, dragTranslation: dragTranslation)
        
        applyOverlayAnimations(to: card, showDirection: direction, duration: overlayDuration) { (_, finished) in
            if finished {
                self.applyRotationAnimation(to: card, rotationAngle: rotation, duration: self.cardStack.options.cardSwipeAnimationMaximumDuration, completionBlock: nil)
                self.applyTranslationAnimation(to: card, translation: translation, duration: self.cardStack.options.cardSwipeAnimationMaximumDuration) { _, finished in
                    if finished {
                        card.layer.shouldRasterize = false
                    }
                    completion?(finished)
                }
            }
        }
    }

    open func applyReverseSwipeAnimation(to card: MGSwipeCard?, from direction: SwipeDirection, completion: ((Bool) -> Void)?) {
        guard let card = card else { return }
        removeAllAnimations(on: card)
        isResettingCard = true
        
        //recreate swipe transform
        card.transform = CGAffineTransform.identity
        card.transform.tx = translationPoint(card, direction: direction, dragTranslation: direction.point).x
        card.transform.ty = translationPoint(card, direction: direction, dragTranslation: direction.point).y
        if direction == .left {
            card.transform = card.transform.rotated(by: -2 * card.options.maximumRotationAngle)
        } else if direction == .right {
            card.transform = card.transform.rotated(by: 2 * card.options.maximumRotationAngle)
        }
        applyOverlayAnimations(to: card, showDirection: direction, duration: 0, completionBlock: nil)
        
        applyRotationAnimation(to: card, rotationAngle: 0, duration: cardStack.options.cardUndoAnimationDuration, completionBlock: nil)
        applyTranslationAnimation(to: card, translation: .zero, duration: cardStack.options.cardUndoAnimationDuration) { _, finished in
            if finished {
                card.layer.shouldRasterize = false
                self.applyOverlayAnimations(to: card, showDirection: nil, duration: self.cardStack.options.cardOverlayFadeInOutDuration, completionBlock: { _, finished in
                    if finished {
                        self.isResettingCard = false
                    }
                    completion?(finished)
                })
            }
        }
    }
    
    open func applyResetAnimation(to card: MGSwipeCard?, completion: ((Bool) -> Void)?) {
        guard let card = card else { return }
        removeAllAnimations(on: card)
        isResettingCard = true
        
        card.layer.shouldRasterize = true
        card.layer.rasterizationScale = UIScreen.main.scale

        if let resetTranslationAnimation = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY) {
            resetTranslationAnimation.toValue = CGPoint.zero
            resetTranslationAnimation.springBounciness = cardStack.options.cardResetAnimationSpringBounciness
            resetTranslationAnimation.springSpeed = cardStack.options.cardResetAnimationSpringSpeed
            resetTranslationAnimation.completionBlock = { _, finished in
                if finished {
                    card.layer.shouldRasterize = false
                    self.isResettingCard = false
                }
                completion?(finished)
            }
            card.layer.pop_add(resetTranslationAnimation, forKey: CardStackAnimator.springTranslationKey)
        }
        
        if let resetRotationAnimation = POPSpringAnimation(propertyNamed: kPOPLayerRotation) {
            resetRotationAnimation.toValue = 0
            resetRotationAnimation.springBounciness = cardStack.options.cardResetAnimationSpringBounciness
            resetRotationAnimation.springSpeed = cardStack.options.cardResetAnimationSpringSpeed
            card.layer.pop_add(resetRotationAnimation, forKey: CardStackAnimator.springRotationKey)
        }

        card.swipeDirections.forEach { direction in
            if let resetOverlayAnimation = POPSpringAnimation(propertyNamed: kPOPViewAlpha) {
                resetOverlayAnimation.toValue = 0
                resetOverlayAnimation.springBounciness = cardStack.options.cardResetAnimationSpringBounciness
                resetOverlayAnimation.springSpeed = cardStack.options.cardResetAnimationSpringSpeed
                card.overlay(forDirection: direction)?.pop_add(resetOverlayAnimation, forKey: CardStackAnimator.springOverlayAlphaKey)
            }
        }
    }
    
    open func removeAllAnimations(on card: MGSwipeCard?) {
        guard let card = card else { return }
        isResettingCard = false
        for key in CardStackAnimator.cardAnimationKeys {
            card.layer.pop_removeAnimation(forKey: key)
            card.pop_removeAnimation(forKey: key)
            card.swipeDirections.forEach { direction in
                card.overlay(forDirection: direction)?.pop_removeAnimation(forKey: key)
            }
        }
        card.layer.shouldRasterize = false
    }

    //MARK: - Private
    
    //does not exactly match user's swipe speed. Becomes more accurate the smaller card.options.maximumSwipeDuration is
    private func translationPoint(_ card: MGSwipeCard, direction: SwipeDirection, dragTranslation: CGPoint) -> CGPoint {
        let cardDiagonalLength = CGPoint.zero.distance(to: CGPoint(x: card.bounds.width, y: card.bounds.height))
        let minimumOffscreenTranslation = CGPoint(x: UIScreen.main.bounds.width + cardDiagonalLength, y: UIScreen.main.bounds.height + cardDiagonalLength)
        let maxLength = max(abs(dragTranslation.x), abs(dragTranslation.y))
        let directionVector = CGPoint(x: dragTranslation.x / maxLength, y: dragTranslation.y / maxLength)
        let velocityFactor = max(1, card.swipeSpeed(on: direction) / card.options.minimumSwipeSpeed)
        return CGPoint(x: velocityFactor * directionVector.x * minimumOffscreenTranslation.x, y: velocityFactor * directionVector.y * minimumOffscreenTranslation.y)
    }
    
    private func rotationForSwipe(_ card: MGSwipeCard, direction: SwipeDirection) -> CGFloat {
        if direction == .up || direction == .down { return 0 }
        if let location = card.touchPoint {
            if (direction == .left && location.y < card.bounds.height / 2) || (direction == .right && location.y >= card.bounds.height / 2) { return -2 * card.options.maximumRotationAngle}
        }
        return 2 * card.options.maximumRotationAngle
    }
    
    private func randomRotationForSwipe(_ card: MGSwipeCard, direction: SwipeDirection) -> CGFloat {
        switch direction {
        case .up, .down: return 0
        case .left, .right: return Array([-1,1])[Int(arc4random_uniform(UInt32(2)))] * (2 * card.options.maximumRotationAngle)
        }
    }
    
    //MARK: Pop Animations
    
    private func applyOverlayAnimations(to card: MGSwipeCard, showDirection: SwipeDirection?, duration: CFTimeInterval, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        var completionCalled = false
        for direction in card.swipeDirections {
            let overlay = card.overlay(forDirection: direction)
            let alpha: CGFloat = direction == showDirection ? 1 : 0
            applyAlphaAnimation(to: overlay, alpha: alpha, duration: duration) { (animation, finished) in
                if !completionCalled {
                    completionBlock?(animation, finished)
                    completionCalled = true
                }
            }
        }
    }
    
    private func applyScaleAnimation(to view: UIView, scaleFactor: CGFloat, beginTime: CFTimeInterval = 0, duration: CFTimeInterval, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        if duration == 0 {
            view.transform = view.transform.scaledBy(x: scaleFactor, y: scaleFactor)
            completionBlock?(nil, true)
            return
        }
        if view.transform == CGAffineTransform.identity && scaleFactor == 1 {
            completionBlock?(nil, true)
            return
        }
        if let scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY) {
            scaleAnimation.duration = duration
            scaleAnimation.toValue = CGSize(width: scaleFactor, height: scaleFactor)
            scaleAnimation.beginTime = beginTime
            scaleAnimation.completionBlock = completionBlock
            view.pop_add(scaleAnimation, forKey: CardStackAnimator.scaleKey)
        }
    }
    
    private func applyTranslationAnimation(to view: UIView, translation: CGPoint, duration: CFTimeInterval, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        if duration == 0 {
            view.transform = view.transform.translatedBy(x: translation.x, y: translation.y)
            completionBlock?(nil, true)
            return
        }
        if let translationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerTranslationXY) {
            translationAnimation.duration = duration
            translationAnimation.toValue = translation
            translationAnimation.completionBlock = completionBlock
            view.layer.pop_add(translationAnimation, forKey: CardStackAnimator.translationKey)
        }
    }

    private func applyRotationAnimation(to view: UIView, rotationAngle: CGFloat, duration: CFTimeInterval, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        if duration == 0 {
            view.transform = view.transform.rotated(by: rotationAngle)
            completionBlock?(nil, true)
            return
        }
        if let rotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotation) {
            rotationAnimation.duration = duration
            rotationAnimation.toValue = rotationAngle
            rotationAnimation.completionBlock = completionBlock
            view.layer.pop_add(rotationAnimation, forKey: CardStackAnimator.rotationKey)
        }
    }
    
    private func applyAlphaAnimation(to view: UIView?, alpha: CGFloat, duration: CFTimeInterval, completionBlock: ((POPAnimation?, Bool) -> Void)?) {
        if duration == 0 || view == nil {
            view?.alpha = alpha
            completionBlock?(nil, true)
            return
        }
        if let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha) {
            alphaAnimation.duration = duration
            alphaAnimation.toValue = alpha
            alphaAnimation.completionBlock = { animation, finished in
                completionBlock?(animation, finished)
            }
            view?.pop_add(alphaAnimation, forKey: CardStackAnimator.overlayAlphaKey)
        }
    }

}

extension CardStackAnimator {
    
    public static var scaleKey = "scaleAnimation"
    public static var translationKey = "translationAnimation"
    public static var rotationKey = "rotationAnimation"
    public static var overlayAlphaKey = "overlayAlphaAnimation"
    public static var springTranslationKey = "springTranslationAnimation"
    public static var springRotationKey = "springRotationAnimation"
    public static var springOverlayAlphaKey = "springOverlayAlphaAnimation"
    
    public static var cardAnimationKeys = [
        scaleKey,
        translationKey,
        rotationKey,
        springTranslationKey,
        springRotationKey,
        overlayAlphaKey,
        springOverlayAlphaKey
    ]
    
}


