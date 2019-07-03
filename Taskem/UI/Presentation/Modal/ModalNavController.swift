//
//  ModalNavController.swift
//  Taskem
//
//  Created by Wilson on 16.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ModalNavController: UINavigationController, ThemeObservable {

    convenience init(controller: UIViewController) {
        self.init(rootViewController: controller)
        
        self.isNavigationBarHidden = true
        self.modalPresentationStyle = .custom
        self.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeAppTheme()
    }
    
    public func applyTheme(_ theme: AppTheme) {
        view.layer.shadowColor      = theme.modalViewShadow.cgColor
        view.layer.shadowOffset     = .init(width: 0, height: 1)
        view.layer.shadowOpacity    = 0.7
        view.layer.shadowRadius     = 10
        view.layer.cornerRadius     = 20
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let controller = self.topViewController as? ModalPresentable {
            controller.willDismiss()
        }
        super.dismiss(animated: flag, completion: completion)
    }
}

extension ModalNavController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let transitionView = UIView()
        transitionView.backgroundColor = AppTheme.current.background
        transitionView.accessibilityIdentifier = "ModalNavControllerTransitionView"
        transitionView.alpha = 1
        
        viewController.view.addSubview(transitionView)
        transitionView.anchorSuperView()
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let transitionView = viewController.view.subviews.first(where: { $0.accessibilityIdentifier == "ModalNavControllerTransitionView" }) else { return }
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            transitionView.alpha = 0
        }
        animator.addCompletion { position in
            if position == .end {
                transitionView.removeFromSuperview()
            }
        }
        animator.startAnimation()
    }
}
