//
//  UIImage+Icons.swift
//  Taskem
//
//  Created by Wilson on 12/6/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

extension UIImage {
    static func onboarding1(_ theme: AppTheme) -> UIImage {
        return theme == .light ? Icons.icOnboardingLight1.image : Icons.icOnboardingDark1.image
    }
    
    static func onboarding2(_ theme: AppTheme) -> UIImage {
        return theme == .light ? Icons.icOnboardingLight2.image : Icons.icOnboardingDark2.image
    }
    
    static func onboarding3(_ theme: AppTheme) -> UIImage {
        return theme == .light ? Icons.icOnboardingLight3.image : Icons.icOnboardingDark3.image
    }
}
