//
//  RepeatTypeTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 08.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class RepeatTypeTableViewCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!

    @IBAction func touchType(_ sender: UIButton) {
        touchRepeatType?(sender.tag)
        select(where: { $0 == sender })
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        observeAppTheme()
    }

    var touchRepeatType: ((_ index: Int) -> Void)?

    private var buttons: [UIButton] {
        return contentView.subviewsOf(view: contentView)
    }
    
    private func select(rule: RepeatModelData.Model) {
        switch rule {
        case .daily:
            select(where: { [weak self] button in
                return button == self?.dailyButton
            })

        case .weekly:
            select(where: { [weak self] button in
                return button == self?.weeklyButton
            })

        case .monthly:
            select(where: { [weak self] button in
                return button == self?.monthlyButton
            })

        case .yearly:
            select(where: { [weak self] button in
                return button == self?.yearlyButton
            })
        }
    }
    
    private func select(where predicate: (UIButton) -> Bool) {
        let palette = Color.TaskemMain.self
        
        buttons.forEach { button in
            if predicate(button) {
                button.backgroundColor = palette.blue
                button.setTitleColor(palette.white, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(palette.blue, for: .normal)
            }
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        title.textColor                 = theme.secondTitle
        backgroundColor                 = theme.background
        contentView.backgroundColor     = theme.background
        tintColor                       = theme.secondTitle
    }

    func setup(_ viewModel: RepeatModelData) {
        select(rule: viewModel.selected)
        
        for type in viewModel.cases {
            switch type {
            case .daily:
                dailyButton.setTitle(type.rawValue, for: .normal)
            case .weekly:
                weeklyButton.setTitle(type.rawValue, for: .normal)
            case .monthly:
                monthlyButton.setTitle(type.rawValue, for: .normal)
            case .yearly:
                yearlyButton.setTitle(type.rawValue, for: .normal)
            }
        }
    }
}
