//
//  UIImage+Helpers.swift
//  Taskem
//
//  Created by Wilson on 3/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension UIImage {
    convenience init?(icon: Icon) {
        self.init(named: icon.name, in: icon.bundle, compatibleWith: nil)
    }
}
