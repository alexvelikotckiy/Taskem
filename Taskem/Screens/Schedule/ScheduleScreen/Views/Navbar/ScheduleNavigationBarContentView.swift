//
//  ScheduleNavigationBarContentView.swift
//  Taskem
//
//  Created by Wilson on 10/3/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleNavigationBarContentView: XibFileView {
    
    @IBOutlet weak var stackView: ScheduleNavigationBarStackView!
    
    public init(maxWidth: CGFloat) {
        super.init(frame: .zero)
        
        self.stackView.maxWidth = maxWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload(_ cells: [ScheduleNavigationBarCell]) {
        stackView.reload(cells)
    }
    
    public func removeAllViews() {
        stackView.removeAllViews()
    }
}
