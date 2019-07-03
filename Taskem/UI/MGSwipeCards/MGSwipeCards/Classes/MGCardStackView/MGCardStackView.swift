//
//  MGCardStackView.swift
//  MGSwipeCards
//
//  Created by Mac Gallagher on 5/4/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

open class MGCardStackView: UIView {
    
    private struct State {
        static var emptyState = State(remainingIndices: [], lastSwipedCardIndex: nil, lastSwipedDirection: nil)
        var remainingIndices: [Int]
        var lastSwipedCardIndex: Int?
        var lastSwipedDirection: SwipeDirection?
    }
    
    public var delegate: MGCardStackViewDelegate? {
        didSet {
            reloadData()
            layoutIfNeeded()
        }
    }

    public var dataSource: MGCardStackViewDataSource? {
        didSet { reloadData() }
    }
    
    public var options: MGCardStackViewOptions {
        return delegate?.additionalOptions(self) ?? MGCardStackViewOptions.defaultOptions
    }
    
    private lazy var animator = CardStackAnimator(cardStack: self)
    
    private var visibleCards: [MGSwipeCard] = []
    private var topCard: MGSwipeCard? {
        return visibleCards.first ?? nil
    }
    
    private var states: [State] = []
    private var currentState: State {
        return states.last ?? State.emptyState
    }
    public var currentCardIndex: Int {
        return currentState.remainingIndices.first ?? 0
    }
    
    private var cardStack = UIView()
    
    //MARK: - Initialization
    
    public init() {
        super.init(frame: .zero)
        sharedInit()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(cardStack)
    }
    
    //MARK: - Layout

    open override func layoutSubviews() {
        super.layoutSubviews()
        cardStack.frame = CGRect(x: options.cardStackInsets.left,
                                 y: options.cardStackInsets.top,
                                 width: bounds.width - options.cardStackInsets.left - options.cardStackInsets.right,
                                 height: bounds.height - options.cardStackInsets.top - options.cardStackInsets.bottom)
        layoutCards()
    }
    
    private func layoutCards() {
        for (index, card) in visibleCards.enumerated() {
            layoutCard(card, at: index)
        }
    }
    
    private func layoutCard(_ card: MGSwipeCard?, at index: Int) {
        card?.transform = CGAffineTransform.identity
        card?.frame = cardStack.bounds
        if index == 0 {
            card?.isUserInteractionEnabled = true
        } else {
            card?.isUserInteractionEnabled = false
            card?.transform = CGAffineTransform(scaleX: options.backgroundCardScaleFactor, y: options.backgroundCardScaleFactor)
        }
    }
    
    //MARK: - Data Source
    
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        let numberOfCards = dataSource.numberOfCards(in: self)
        states = []
        states.append(State(remainingIndices: Array(0..<numberOfCards), lastSwipedCardIndex: nil, lastSwipedDirection: nil))
        loadState(atStateArrayIndex: 0)
    }
    
    private func loadState(atStateArrayIndex index: Int) {
        visibleCards.forEach { card in
            card.removeFromSuperview()
        }
        visibleCards = []
        states.removeLast(states.count - (index + 1))
        for index in 0..<min(currentState.remainingIndices.count, options.numberOfVisibleCards) {
            if let card = reloadCard(at: currentState.remainingIndices[index]) {
                insertCard(card, at: index)
            }
        }
    }
    
    private func reloadCard(at index: Int) -> MGSwipeCard? {
        guard let dataSource = dataSource else { return nil }
        let card = dataSource.cardStack(self, cardForIndexAt: index)
        card.delegate = self
        return card
    }
    
    private func insertCard(_ card: MGSwipeCard, at index: Int) {
        cardStack.insertSubview(card, at: visibleCards.count - index)
        visibleCards.insert(card, at: index)
        layoutCard(card, at: index)
    }
    
    //MARK: - Main Methods
    
    public func swipe(_ direction: SwipeDirection, randomLeftRightRotation: Bool = true) {
        if let topCard = topCard {
            if !topCard.isUserInteractionEnabled || animator.isResettingCard { return }
            topCard.isUserInteractionEnabled = false
            animator.applySwipeAnimation(to: topCard, direction: direction, forced: true) { finished in
                if finished {
                    topCard.removeFromSuperview()
                }
            }
            handleSwipe(topCard, direction: direction)
        }
    }
    
    private func handleSwipe(_ card: MGSwipeCard, direction: SwipeDirection) {
        delegate?.cardStack(self, didSwipeCardAt: currentCardIndex, with: direction)
        visibleCards.remove(at: 0)
        let newCurrentState = State(remainingIndices: Array(currentState.remainingIndices.dropFirst()), lastSwipedCardIndex: currentCardIndex, lastSwipedDirection: direction)
        states.append(newCurrentState)

        if newCurrentState.remainingIndices.count == 0 {
            delegate?.didSwipeAllCards(self)
            return
        }

        if newCurrentState.remainingIndices.count - visibleCards.count > 0 {
            let bottomCardIndex = currentState.remainingIndices[visibleCards.count]
            if let card = reloadCard(at: bottomCardIndex) {
                cardStack.insertSubview(card, at: 0)
                visibleCards.insert(card, at: visibleCards.count)
                layoutCard(card, at: visibleCards.count)
            }
        }

        for (index, card) in visibleCards.enumerated() {
            animator.applyScaleAnimation(to: card, at: index, duration: options.backgroundCardScaleAnimationDuration, delay: options.cardOverlayFadeInOutDuration) { _ in
                self.topCard?.isUserInteractionEnabled = true
            }
        }
        
    }
    
    public func undoLastSwipe() {
        if states.count <= 1 || animator.isResettingCard { return }
        if topCard != nil && !topCard!.isUserInteractionEnabled { return }
        guard let lastSwipedIndex = currentState.lastSwipedCardIndex, let direction = currentState.lastSwipedDirection else { return }

        delegate?.cardStack(self, didUndoSwipeOnCardAt: lastSwipedIndex, from: direction)
        
        loadState(atStateArrayIndex: self.states.count - 2)
        topCard?.isUserInteractionEnabled = false
        animator.applyReverseSwipeAnimation(to: topCard, from: direction) { finished in
            if finished {
                self.topCard?.isUserInteractionEnabled = true
            }
        }
        if visibleCards.count > 1 {
            visibleCards[1].transform = CGAffineTransform.identity
            for index in 1..<visibleCards.count {
                animator.applyScaleAnimation(to: visibleCards[index], at: index, duration: options.backgroundCardResetAnimationDuration, completion: nil)
            }
        }
    }
    
    public func shift(withDistance distance: Int = 1, animated: Bool) {
        if distance == 0 || visibleCards.count <= 1 { return }
        if !topCard!.isUserInteractionEnabled || animator.isResettingCard { return }
        let newCurrentState = State(remainingIndices: currentState.remainingIndices.shift(withDistance: distance), lastSwipedCardIndex: currentState.lastSwipedCardIndex, lastSwipedDirection: currentState.lastSwipedDirection)
        states.removeLast()
        states.append(newCurrentState)
        loadState(atStateArrayIndex: self.states.count - 1)
        
        if !animated { return }
        if distance > 0 {
            let scaleFactor = options.forwardShiftAnimationInitialScaleFactor
            topCard?.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        } else {
            let scaleFactor = options.backwardShiftAnimationInitialScaleFactor
            topCard?.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
        
        topCard?.isUserInteractionEnabled = false
        animator.applyScaleAnimation(to: topCard, at: 0, duration: 0.1) { _ in
            self.topCard?.isUserInteractionEnabled = true
        }
    }
    
}

//MARK: - MGSwipeCardDelegate

extension MGCardStackView: MGSwipeCardDelegate {
    
    public func card(didTap card: MGSwipeCard) {
        delegate?.cardStack(self, didSelectCardAt: currentCardIndex)
        
        let location = card.tapGestureRecognizer.location(in: card.superview)
        let topCorner: UIRectCorner
        if location.x < card.bounds.width / 2 {
            topCorner = location.y < card.bounds.height / 2 ? .topLeft : .bottomLeft
        } else {
            topCorner = location.y < card.bounds.height / 2 ? .topRight : .bottomRight
        }
        delegate?.cardStack(self, didSelectCardAt: currentCardIndex, tapCorner: topCorner)
    }
    
    public func card(didBeginSwipe card: MGSwipeCard) {
        visibleCards.forEach { card in
            animator.removeAllAnimations(on: card)
        }
    }
    
    public func card(didContinueSwipe card: MGSwipeCard) {
       card.swipeDirections.forEach { direction in
            card.overlay(forDirection: direction)?.alpha = alphaForOverlay(card, with: direction)
        }
        
        if visibleCards.count <= 1 { return }
        let translation = card.panGestureRecognizer.translation(in: cardStack)
        let minimumSideLength = min(cardStack.bounds.width, cardStack.bounds.height)
        let percentTranslation = max(min(1, 2 * abs(translation.x)/minimumSideLength), min(1, 2 * abs(translation.y)/minimumSideLength))
        let scaleFactor = options.backgroundCardScaleFactor + (1 - options.backgroundCardScaleFactor) * percentTranslation
        let nextCard = visibleCards[1]
        nextCard.layer.setAffineTransform(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        
        func alphaForOverlay(_ card: MGSwipeCard, with direction: SwipeDirection) -> CGFloat {
            if direction != card.activeDirection { return 0 }
            let totalPercentage = card.swipeDirections.reduce(0) { (percentage, direction) in
                return percentage + card.swipePercentage(on: direction)
            }
            return min((2 * card.swipePercentage(on: direction) - totalPercentage)/card.options.minimumSwipeMargin, 1)
        }
    }
    
    public func card(didSwipe card: MGSwipeCard, with direction: SwipeDirection) {
        card.isUserInteractionEnabled = false
        animator.applySwipeAnimation(to: card, direction: direction) { _ in
            card.removeFromSuperview()
        }
        handleSwipe(card, direction: direction)
    }
    
    public func card(didCancelSwipe card: MGSwipeCard) {
        animator.applyResetAnimation(to: card, completion: nil)
        for index in 1..<visibleCards.count {
            animator.applyScaleAnimation(to: visibleCards[index], at: index, duration: options.backgroundCardResetAnimationDuration, completion: nil)
        }
    }
    
}












