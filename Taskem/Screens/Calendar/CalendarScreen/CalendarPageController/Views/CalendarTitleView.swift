//
//  CalendarTitleView.swift
//  Taskem
//
//  Created by Wilson on 1/20/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar

class CalendarTitleView: XibFileView, ThemeObservable {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var chevron: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func onSelect(_ sender: Any) {
        toogle()
        onToogle?(isUp)
    }
    
    public var onToogle: ((Bool) -> Void)?
    
    public var isUp = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button.isExclusiveTouch = true
        
        observeAppTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor = theme.navBarTitle
        chevron.tintColor = theme.navBarTitle
    }
    
    public func setScope(calendarScope: FSCalendarScope) {
        switch calendarScope {
        case .week where !isUp:
            toogle()
            
        case .month where isUp:
            toogle()
            
        default:
            break
        }
    }
    
    private func toogle() {
        let transform = isUp ? CGAffineTransform(scaleX: 1, y: -1) : CGAffineTransform.identity
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.chevron.transform = transform
        }
        self.isUp = !self.isUp
        animator.startAnimation()
    }
}
