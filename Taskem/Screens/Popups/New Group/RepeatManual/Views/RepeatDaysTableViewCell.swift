//
//  RepeatDaysTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 08.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class RepeatDaysTableViewCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var sunday: BorderRoundButton!
    @IBOutlet weak var monday: BorderRoundButton!
    @IBOutlet weak var tuesday: BorderRoundButton!
    @IBOutlet weak var wednesday: BorderRoundButton!
    @IBOutlet weak var thursday: BorderRoundButton!
    @IBOutlet weak var friday: BorderRoundButton!
    @IBOutlet weak var saturday: BorderRoundButton!

    @IBAction func touchDaysOfWeek(_ sender: UIButton) {
        touchDay?(sender.tag)
        select(where: { $0 == sender })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor                 = theme.secondTitle
        backgroundColor                 = theme.background
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.secondTitle
    }

    private var buttons: [UIButton] {
        return contentView.subviewsOf(view: contentView)
    }
    
    private func select(where predicate: (UIButton) -> Bool) {
        let palette = Color.TaskemMain.self
        
        buttons.forEach { button in
            if predicate(button) {
                if self.isSelected(button: button) {
                    button.backgroundColor = .clear
                    button.setTitleColor(palette.blue, for: .normal)
                } else {
                    button.backgroundColor = palette.blue
                    button.setTitleColor(palette.white, for: .normal)
                }
            }
        }
    }
    
    private func select(withTags tags: [Int]) {
        select(where: { tags.contains($0.tag) })
    }
    
    private func isSelected(button: UIButton) -> Bool {
        return button.titleLabel?.textColor == Color.TaskemMain.white
    }
    
    var touchDay: ((_ index: Int) -> Void)?
    
    func setup(_ viewModel: RepeatDaysOfWeekData) {
        select(withTags: viewModel.selected)
        
        for (index, button) in buttons.enumerated() {
            button.setTitle(viewModel.days[index], for: .normal)
        }
    }
}
