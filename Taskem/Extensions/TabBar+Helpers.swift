//
//  TabBar+Helpers.swift
//  Taskem
//
//  Created by Wilson on 30.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public extension UITabBarController {

    func onScrollAppearance(translation: CGFloat, animated: Bool, views: [UIView]) {
        if let window = UIApplication.shared.keyWindow {
            let tapBarPositionYTransform: CGFloat = 50.0 + window.safeAreaInsets.bottom
            let positionYTransform: CGFloat = 50.0
            UIView.animate(withDuration: animated ? 0.3 : 0.0, animations: {
                if translation < 0 {
                    self.tabBar.transform = CGAffineTransform(translationX: 0, y: tapBarPositionYTransform)
                    views.forEach { $0.transform = CGAffineTransform(translationX: 0, y: positionYTransform) }
                } else {
                    self.tabBar.transform = CGAffineTransform.identity
                    views.forEach { $0.transform = CGAffineTransform.identity }
                }
            }) { _ in

            }
        }
    }

}
