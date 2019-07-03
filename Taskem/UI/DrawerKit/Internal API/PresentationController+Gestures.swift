import UIKit

extension DrawerPresentationController {
    @objc func handleDrawerFullExpansionTap() {
        guard let tapGesture = drawerFullExpansionTapGR,
            shouldBeginTransition else { return }
        let tapY = tapGesture.location(in: presentedView).y
        guard tapY < drawerPartialHeight else { return }
        NotificationCenter.default.post(notification: DrawerNotification.drawerInteriorTapped)
        animateTransition(to: .fullyExpanded)
    }

    @objc func handleDrawerDismissalTap() {
        guard let tapGesture = drawerDismissalTapGR,
            shouldBeginTransition else { return }
        let tapY = tapGesture.location(in: containerView).y
        guard tapY < currentDrawerY else { return }
        NotificationCenter.default.post(notification: DrawerNotification.drawerExteriorTapped)
        tapGesture.isEnabled = false
        presentedViewController.dismiss(animated: true)
    }

    @objc func handleDrawerDrag() {
        guard let panGesture = drawerDragGR,
            let view = panGesture.view,
            shouldBeginTransition else { return }

        switch panGesture.state {
        case .began:
            startingDrawerStateForDrag = targetDrawerState
            fallthrough

        case .changed:
            applyTranslationY(panGesture.translation(in: view).y)
            panGesture.setTranslation(.zero, in: view)

        case .ended:
            let drawerSpeedY = panGesture.velocity(in: view).y / containerViewHeight
            let endingState = GeometryEvaluator.nextStateFrom(currentState: currentDrawerState,
                                                              speedY: drawerSpeedY,
                                                              drawerPartialHeight: drawerPartialHeight,
                                                              containerViewHeight: containerViewHeight,
                                                              configuration: configuration)
            animateTransition(to: endingState)

        case .cancelled:
            if let startingState = startingDrawerStateForDrag {
                startingDrawerStateForDrag = nil
                animateTransition(to: startingState)
            }

        default:
            break
        }
    }

    func applyTranslationY(_ translationY: CGFloat) {
        guard shouldBeginTransition else { return }
        currentDrawerY += translationY
        targetDrawerState = currentDrawerState
        currentDrawerCornerRadius = cornerRadius(at: currentDrawerState)
        
        let (startingPositionY, endingPositionY) = positionsY(startingState: currentDrawerState,
                                                              endingState: targetDrawerState)
        
        let presentingVC = presentingViewController
        let presentedVC = presentedViewController
        
        let presentedViewFrame = presentedView?.frame ?? .zero
        
        var startingFrame = presentedViewFrame
        startingFrame.origin.y = startingPositionY
        
        var endingFrame = presentedViewFrame
        endingFrame.origin.y = endingPositionY
        
        let geometry = AnimationSupport.makeGeometry(containerBounds: containerViewBounds,
                                                     startingFrame: startingFrame,
                                                     endingFrame: endingFrame,
                                                     presentingVC: presentingVC,
                                                     presentedVC: presentedVC)
        
        let info = AnimationSupport.makeInfo(startDrawerState: currentDrawerState,
                                             targetDrawerState: targetDrawerState,
                                             configuration,
                                             geometry,
                                             0.0,
                                             false)
        
        let presentingAnimationActions = self.presentingDrawerAnimationActions
        let presentedAnimationActions = self.presentedDrawerAnimationActions
        
        AnimationSupport.clientAnimateAlong(presentingDrawerAnimationActions: presentingAnimationActions,
                                            presentedDrawerAnimationActions: presentedAnimationActions,
                                            info)
    }
}

extension DrawerPresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer,
           let view = gestureRecognizer.view,
           view.isDescendant(of: presentedViewController.view),
           let subview = view.hitTest(touch.location(in: view), with: nil) {
            return !(subview is UIControl)
        } else {
            return true
        }
    }
}
