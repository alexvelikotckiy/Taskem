//
//  RescheduleCardContentView.swift
//  Taskem
//
//  Created by Wilson on 8/22/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleCardContentView: XibFileView, ThemeObservable {
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var planned: UILabel!
    @IBOutlet weak var plannedSubtitle: UILabel!
    
    @IBOutlet weak var groupView: DesignableView!
    @IBOutlet weak var groupIcon: UIImageView!
    
    init(model: RescheduleViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        title.text = model.name
        planned.text = model.planned
        plannedSubtitle.text = model.plannedSubtitle
        
        groupView.backgroundColor = model.group.color.uicolor
        groupIcon.image = model.group.icon.image
        
        background.backgroundColor = model.group.color.uicolor.withAlphaComponent(0.4)
        
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme(_ theme: AppTheme) {
        title.textColor             = theme.blackTitle
        planned.textColor           = theme.firstTitle
        plannedSubtitle.textColor   = theme.firstTitle
    }
}
