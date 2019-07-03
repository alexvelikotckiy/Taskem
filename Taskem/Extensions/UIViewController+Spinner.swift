//
//  UIViewController+Spinner.swift
//  Taskem
//
//  Created by Wilson on 6/29/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension UIViewController {
    func showSpinner(_ visible: Bool) {
        if visible {
            displaySpinner()
        } else {
            removeSpinner()
        }
    }
    
    func displaySpinner() {
//        guard view.viewWithTag(1000) == nil else { return }
//
//        let spinnerView = UIView.init(frame: view.frame)
//        spinnerView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.3)
//        spinnerView.tag = 1000
//        let ai = UIActivityIndicatorView.init(style: .gray)
//        ai.startAnimating()
//        ai.center = spinnerView.center
//
//        spinnerView.addSubview(ai)
//        view.addSubview(spinnerView)
    }

    func removeSpinner() {
//        if let spinner = view.viewWithTag(1000) {
//            spinner.removeFromSuperview()
//        }
    }
}
