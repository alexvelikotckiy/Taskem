//
//  ExpandInteractiveTransitioning.swift
//  ExpandTest
//
//  Created by Wilson on 27.02.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

class ExpandInteractiveTransitioning: UIPercentDrivenInteractiveTransition {
    weak var viewController: UIViewController?
    weak var presentingViewController: UIViewController?
    weak var expandAdapter: ExpandTransitioningAdapter?

    weak var dismissAnimator: ExpandDismissingAnimator?

    var panGestureRecognizer: UIPanGestureRecognizer
    var shouldComplete = false
    
    var startOffset: CGFloat = 0
    
    var isTransitioning = false {
        didSet {
            if isTransitioning {
                expandAdapter?.willBeginInteractiveTransitioning()
            } else {
                expandAdapter?.didEndInteractiveTransitioning()
            }
        }
    }

    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController

        self.panGestureRecognizer = UIPanGestureRecognizer()
        
        super.init()

        self.panGestureRecognizer.addTarget(self, action: #selector(self.handlePan))
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.cancelsTouchesInView = false
        self.presentingViewController?.view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
        case .began:
            break
            
        case .changed:
            if !isTransitioning {
                startTransitionIfNeed(pan: pan)
            } else {
                let screenHeight = UIScreen.main.bounds.size.height
                let dragAmount = screenHeight
                let threshold: Float = 0.25
                var offset: Float = Float(translation.y - startOffset) / Float(dragAmount)
                
                offset = fmaxf(offset, -1.0)
                offset = fminf(offset, 1.0)
                
                update(CGFloat(offset))
                shouldComplete = abs(offset) > threshold
            }
            
        case .ended, .cancelled:
            
//            if pan.velocity(in: pan.view).y > 150 {
//                finish()
//                isTransitioning = false
//                return
//            }
            
            if pan.state == .cancelled || !shouldComplete {
                cancel()
            } else {
                finish()
            }
            isTransitioning = false
            
        default:
            cancel()
            isTransitioning = false
        }
    }

    private func startTransitionIfNeed(pan: UIPanGestureRecognizer) {
        guard expandAdapter?.shouldBeginExpandInteractiveTransitioning() ?? false else { return }
        
        if abs(pan.velocity(in: pan.view).y) > abs(pan.velocity(in: pan.view).x) {
            presentingViewController?.dismiss(animated: true, completion: nil)
            startOffset = pan.translation(in: pan.view?.superview).y
            isTransitioning = true
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)

        dismissAnimator?.transitionContext = transitionContext
        dismissAnimator?.updateTransitionState(state: .start, isInteractive: true)
    }

    override func update(_ percentComplete: CGFloat) {
        super.update(abs(percentComplete))
        dismissAnimator?.updateTransitionState(state: .update(currentPercentage: percentComplete), isInteractive: true)
    }

    override func finish() {
        super.finish()
        dismissAnimator?.updateTransitionState(state: .finish, isInteractive: true)
    }

    override func cancel() {
        super.cancel()
        dismissAnimator?.updateTransitionState(state: .cancel(lastPercentage: percentComplete), isInteractive: true)
    }
}

extension ExpandInteractiveTransitioning: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
