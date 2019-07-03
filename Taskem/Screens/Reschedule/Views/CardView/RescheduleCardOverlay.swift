//
//  RescheduleCardOverlay.swift
//  Taskem
//
//  Created by Wilson on 8/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleCardOverlay: XibFileView {
    
    @IBOutlet weak var iconStackView: UIStackView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconTitle: UILabel!
    
    @IBOutlet weak var descriptionStackView: UIStackView!
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionTitleSubtitle: UILabel!
    @IBOutlet weak var descriptionSubtitle: UILabel!
    
    public init(overlay: RescheduleSwipeOverlay) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        switch overlay.action.description {
        case .icon(let icon):
            iconStackView.isHidden = false
            descriptionStackView.isHidden = true
            
            self.icon.image = icon.image
            iconTitle.text = overlay.action.title
            
        case .description(let title, let subtitle):
            iconStackView.isHidden = true
            descriptionStackView.isHidden = false
            
            descriptionTitle.text = title
            descriptionTitleSubtitle.text = subtitle
            descriptionSubtitle.text = overlay.action.title
        }

        backgroundColor = overlay.action.color.uicolor
        taskem_cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
