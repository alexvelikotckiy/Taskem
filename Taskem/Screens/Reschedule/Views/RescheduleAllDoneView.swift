//
//  RescheduleAllDoneView.swift
//  Taskem
//
//  Created by Wilson on 8/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RescheduleAllDoneView: XibFileView, ThemeObservable {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconPlaceholder: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor           = theme.firstTitle
        subtitle.textColor        = theme.secondTitle
        iconPlaceholder.tintColor = theme.iconPlaceholder
        
        switch theme {
        case .light:
            icon.image = Icons.icNicelyDoneLight.image
            
        case .dark:
            icon.image = Icons.icNicelyDoneDark.image
        }
    }
}
