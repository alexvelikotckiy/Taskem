//
//  ScheduleControlNavigationBarContentView.swift
//  Taskem
//
//  Created by Wilson on 12/31/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class ScheduleControlNavigationBarContentView: XibFileView, ThemeObservable {
    
    @IBOutlet weak var stackView: ScheduleNavigationBarStackView!
    @IBOutlet weak var clear: UIButton!
    
    @IBAction func onTouchClear(_ sender: Any) {
        onClear?()
    }
    
    public init(maxWidth: CGFloat) {
        super.init(frame: .zero)
        
        self.stackView.maxWidth = maxWidth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onClear: (() -> Void)?
    
    func applyTheme(_ theme: AppTheme) {
        clear.tintColor = theme.navBarItem
    }
    
    public func reload(_ cells: [ScheduleNavigationBarCell]) {
        stackView.reload(cells)
        clear.isHidden = stackView.arrangedSubviews.isEmpty
    }
    
    public func removeAllViews() {
        stackView.removeAllViews()
        clear.isHidden = true
    }
}
