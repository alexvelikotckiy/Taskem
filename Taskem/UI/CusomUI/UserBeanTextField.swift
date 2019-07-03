//
//  CustomHoshiTextField.swift
//  Taskem
//
//  Created by Wilson on 12/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TextFieldEffects
import TaskemFoundation

@IBDesignable
class UserBeanTextField: HoshiTextField, ThemeObservable {
    
    private var icon: UIImageView = {
        let image: UIImageView = .init()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    private func setupView() {
        observeAppTheme()
        setupIcon()
        
        font                    = .avenirNext(ofSize: 24, weight: .medium)
        placeholderLabel.font   = .avenirNext(ofSize: 16, weight: .medium)
        placeholder = "Placeholder"
    }
    
    private func setupIcon() {
        addSubview(icon)
        icon.isHidden = true
        
        NSLayoutConstraint.activate(
            [
                icon.widthAnchor.constraint(equalToConstant: 13),
                icon.heightAnchor.constraint(equalToConstant: 13),
                icon.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
                icon.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            ]
        )
    }
    
    func applyTheme(_ theme: AppTheme) {
        borderInactiveColor       = theme.inactiveTextBoxBorder
        borderActiveColor         = theme.activeTextBoxBorder
        placeholderColor          = theme.fourthTitle
        textColor                 = theme.secondTitle
        keyboardAppearance        = theme == .light ? .light : .dark
    }
    
    func setup(_ content: Content, returnKey: UIReturnKeyType = .next) {
        switch content {
        case .none:
            placeholder = ""
            autocorrectionType = .default
            isSecureTextEntry = false
            keyboardType = .default
            
        case .name:
            placeholder = "Name/Login"
            autocorrectionType = .yes
            isSecureTextEntry = false
            keyboardType = .default
            
        case .email:
            placeholder = "Email"
            autocorrectionType = .yes
            isSecureTextEntry = false
            keyboardType = .emailAddress
            
        case .password:
            placeholder = "Password"
            isSecureTextEntry = true
            autocorrectionType = .no
            keyboardType = .default
        }
        returnKeyType = returnKey
        smartDashesType = .no
    }
    
    func isValid(_ isValid: Bool) {
        if isValid {
            icon.image                = Icons.icCorrect.image
            borderActiveColor         = AppTheme.current.activeTextBoxBorder
        } else {
            icon.image                = Icons.icIncorrect.image
            borderActiveColor         = AppTheme.current.activeIncorrectTextBoxBorder
        }
        icon.isHidden = false
        animateViewsForTextEntry()
    }
    
    func clearValidation() {
        observeAppTheme()
        icon.isHidden = true
    }
}

extension UserBeanTextField {
    enum Content {
        case none
        case name
        case email
        case password
    }
}
