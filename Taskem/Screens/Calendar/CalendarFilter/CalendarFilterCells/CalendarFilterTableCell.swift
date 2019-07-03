//
//  CalendarFilterTableCell.swift
//  Taskem
//
//  Created by Wilson on 7/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class CalendarFilterCalendarTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkbox: Checkbox!

    @IBAction func touchCheckbox(_ sender: Any) {
        checkbox.isChecked.toogle()
        onCheckbox?(self)
    }

    var onCheckbox: ((CalendarFilterCalendarTableCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkbox.checkmarkStyle = .circle
        checkbox.borderStyle = .circle
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func setup(_ model: CalendarFilterViewModel) {
        title.text = model.title
        checkbox.isChecked = model.isSelected
        checkbox.setNeedsLayout()
    }
}
