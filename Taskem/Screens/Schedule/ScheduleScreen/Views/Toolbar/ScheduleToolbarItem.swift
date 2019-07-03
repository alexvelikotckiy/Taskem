//
//  ScheduleToolbarItem.swift
//  Taskem
//
//  Created by Wilson on 1/12/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleToolbarItem: XibFileView, ThemeObservable {
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func touch(_ sender: Any) {
        onTouch?()
    }
    
    public var onTouch: (() -> Void)?
    
    public var isEnabled: Bool {
        get {
            return button.isEnabled
        }
        set {
            button.isEnabled = newValue
        }
    }
    
    public init(title: String, image: UIImage) {
        super.init(frame: .zero)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        button.centerVertically(padding: 5)
    }
    
    func applyTheme(_ theme: AppTheme) {
        button.setTitleColor(theme.secondTitle, for: .normal)
        button.tintColor = theme.iconTint
    }
}

fileprivate extension UIButton {
    func centerVertically(padding: CGFloat) {
        let imageSize = imageView?.frame.size ?? .init()
        let titleSize = titleLabel?.frame.size ?? .init()
        
        let totalHeight = (imageSize.height + titleSize.height + padding)
        
        imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom:  -(totalHeight - titleSize.height),
            right: 0
        )
    }
}
