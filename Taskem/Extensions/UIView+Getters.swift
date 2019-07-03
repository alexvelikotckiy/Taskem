//
//  UIView+Getters.swift
//  Taskem
//
//  Created by Wilson on 12/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension UIView {
    func viewsWithType(description: String) -> [UIView] {
        var subviews = [UIView]()
        for subview in self.subviews {
            subviews += subview.viewsWithType(description: description)
            
            let stringFromClass = String(describing: type(of: subview))
            if stringFromClass.contains(description) {
                subviews.append(subview)
            }
        }
        return subviews
    }
    
    func viewsWithTag(tag: Int) -> [UIView] {
        var subviews = [UIView]()
        for subview in self.subviews {
            subviews += subview.viewsWithTag(tag: tag)
            
            if subview.tag == tag {
                subviews.append(subview)
            }
        }
        return subviews
    }
    
    func subviewsOf<T : UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += subviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        return subviews
    }
}
