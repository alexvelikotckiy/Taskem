//
//  ModalPresentable.swift
//  ModalTest
//
//  Created by Wilson on 14.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import UIKit

@objc protocol ModalPresentable where Self: UIViewController {
    func willDismiss()
    @objc optional func frameOfPresentedView() -> CGRect
}

extension ModalPresentable {
    func adjustTo(height: CGFloat, width: CGFloat? = nil, animated: Bool) {
        if let presentationController = navigationController?.presentationController as? ModalPresentationController {
            presentationController.adjustTo(height: height, width: width, animated: animated)
        }
    }

    func adjustTo(size: CGSize, animated: Bool) {
        if let presentationController = navigationController?.presentationController as? ModalPresentationController {
            presentationController.adjustTo(size: size, animated: animated)
        }
    }

}
