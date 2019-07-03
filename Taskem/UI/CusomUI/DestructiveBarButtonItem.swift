//
//  DestructiveBarButtonItem.swift
//  Taskem
//
//  Created by Wilson on 8/19/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class DestructiveBarButtonItem: UIBarButtonItem {
    override init() {
        super.init()
        setupAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAttributes()
    }
    
    override func prepareForInterfaceBuilder() {
        setupAttributes()
        super.prepareForInterfaceBuilder()
    }
    
    func setupAttributes() {
        let itemFont = UIFont(name: "AvenirNext-Regular", size: 16.0)!
        setTitleTextAttributes([.font: itemFont, .foregroundColor: UIColor.red], for: .highlighted)
        setTitleTextAttributes([.font: itemFont, .foregroundColor: UIColor.red], for: .normal)
        setTitleTextAttributes([.font: itemFont, .foregroundColor: UIColor.gray], for: .disabled)
    }
}
