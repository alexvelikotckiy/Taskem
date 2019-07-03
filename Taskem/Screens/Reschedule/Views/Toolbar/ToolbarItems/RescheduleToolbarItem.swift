//
//  RescheduleToolbarItem.swift
//  Taskem
//
//  Created by Wilson on 1/19/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleToolbarItem: XibFileView, ThemeObservable {
    
    @IBOutlet weak var button: PopBounceButton!
    
    @IBAction func onTouch(_ sender: Any) {
        onSelect?(action)
    }
    
    var onSelect: ((RescheduleAction) -> Void)?
    
    private var action: RescheduleAction
    
    init(action: RescheduleAction) {
        self.action = action
        super.init(frame: .zero)

        switch action.description {
        case .icon(let icon):
            setup(icon: icon)
        case .description(let title, let subtitle):
            setup(title: title, subtitle: subtitle)
        }
        
        button.setShadow(
            radius: 10,
            opacity: 0.5,
            offset: .init(),
            color: action.color.uicolor
        )
        button.backgroundColor = action.color.uicolor
        button.isExclusiveTouch = true
        
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: AppTheme) {
        
    }
    
    private func setup(icon: Icon) {
        button.setTitle(nil)
        button.setImage(icon.image)
    }
    
    private func setup(title: String, subtitle: String) {
        button.setImage(nil)
        
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center

        let titleString = NSMutableAttributedString(
            string: title,
            attributes: [
                .font: UIFont.avenirNext(ofSize: 16, weight: .demiBold),
                .foregroundColor: AppTheme.current.whiteTitle,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    style.lineHeightMultiple = 0.9
                    return style
                }()
            ]
        )
        
        let subtitleString = NSMutableAttributedString(
            string: subtitle,
            attributes: [
                .font: UIFont.avenirNext(ofSize: 12, weight: .demiBold),
                .foregroundColor: AppTheme.current.whiteTitle,
                .paragraphStyle: {
                    let style = NSMutableParagraphStyle()
                    style.alignment = .center
                    style.lineHeightMultiple = 0.7
                    return style
                }()
            ]
        )
        
        titleString.append(.init(string: "\n"))
        titleString.append(subtitleString)
        
        button.setAttributedTitle(titleString)
    }
}
