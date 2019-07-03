//
//  UIVIew+CALayer.swift
//  Taskem
//
//  Created by Wilson on 08.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class DesignableView: UIView {
}

extension UIView {

    @IBInspectable
    var taskem_cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var taskem_shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
            setNeedsLayout()
        }
    }

}
