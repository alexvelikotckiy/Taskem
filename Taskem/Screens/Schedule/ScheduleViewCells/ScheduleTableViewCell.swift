//
//  ScheduleTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

protocol ScheduleTableCellDelegete: class {

}

class ScheduleTableViewCell: MCSwipeTableViewCell {

    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var group: UILabel!

    weak var delegateCell: ScheduleTableCellDelegete?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(with model: ScheduleViewModel) {
        self.title.text = model.name
        self.group.text = model.taskEntity().idGroup
    }

}
