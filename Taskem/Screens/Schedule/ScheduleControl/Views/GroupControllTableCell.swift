//
//  GroupControllTableCell.swift
//  Taskem
//
//  Created by Wilson on 3/19/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupControllTableCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overdueCount: UILabel!
    @IBOutlet weak var uncompleteCount: UILabel!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var deleteLeading: NSLayoutConstraint!

    @IBAction func touchDelete(_ sender: Any) {
        onDelete?(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.33) {
            self.backgroundColor = selected ? UIColor.blue.withAlphaComponent(0.05) : UIColor.white
        }
    }

    var onDelete: ((_ cell: GroupControllTableCell) -> Void)?

    func setupEditing(_ editing: Bool, animated: Bool) {
        self.uncompleteCount.isHidden = editing
        self.overdueCount.isHidden = editing
        self.accessoryType = editing ? .disclosureIndicator : .none
        self.layoutIfNeeded()

        UIView.animate(withDuration: animated ? 0.33 : 0.0) {
            self.deleteLeading.constant = editing ? 0.0 : -40.0
            self.layoutIfNeeded()
        }
    }

//    func setup(_ model: GroupControlViewModel) {
//        self.title.text = model.name
//        self.uncompleteCount.text = "\(model.uncompletedCount)"
//        self.uncompleteCount.alpha = model.uncompletedCount == 0 ? 0 : 1
//        self.overdueCount.text = "\(model.overdueCount)"
//        self.overdueCount.alpha = model.overdueCount == 0 ? 0 : 1
//
//        self.delete.isEnabled = model.isRemovable
//        self.delete.backgroundColor = model.isRemovable ? UIColor.lightGray : UIColor.yellow
//    }
}
