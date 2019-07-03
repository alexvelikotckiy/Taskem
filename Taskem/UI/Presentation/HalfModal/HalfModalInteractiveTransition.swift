//
//  HalfModalInteractiveTransition.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 28/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

protocol HalfModalInteractiveTransitionDelegate: class {
    func shouldBeginInteractiveTransition() -> Bool
}

class HalfModalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var viewController: UIViewController?
    weak var presentingViewController: UIViewController?
    var panGestureRecognizer: UIPanGestureRecognizer
    weak var delegate: HalfModalInteractiveTransitionDelegate?

    var shouldComplete: Bool = false

    init(viewController: UIViewController, withView view: UIView, presentingViewController: UIViewController?) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.panGestureRecognizer = UIPanGestureRecognizer()

        self.delegate = self.presentingViewController as? HalfModalNavController

        super.init()

        self.panGestureRecognizer.addTarget(self, action: #selector(onPan))
        self.panGestureRecognizer.delegate = self
        self.panGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(panGestureRecognizer)
    }

    override var completionSpeed: CGFloat {
        get {
            return 1.0 - self.percentComplete
        }
        set {
            super.completionSpeed = newValue
        }
    }

    @objc func onPan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)

        switch pan.state {
        case .began:
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        case .changed:
            let screenHeight = UIScreen.main.bounds.size.height
            let dragAmount = screenHeight
            let threshold: Float = 0.2
            var percent: Float = Float(translation.y) / Float(dragAmount)

            percent = fmaxf(percent, 0.0)
            percent = fminf(percent, 1.0)

            self.update(CGFloat(percent))
            self.shouldComplete = percent > threshold
        case .ended, .cancelled:
            if pan.velocity(in: pan.view).y > 150 {
                self.finish()
                break
            }
            if pan.state == .cancelled || !shouldComplete {
                self.cancel()
            } else {
                self.finish()
            }
        default:
            self.cancel()
        }
    }

}

extension HalfModalInteractiveTransition: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.delegate?.shouldBeginInteractiveTransition() ?? true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}
