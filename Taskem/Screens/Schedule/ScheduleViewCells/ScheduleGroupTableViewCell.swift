//
//  ScheduleGroupTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 20.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit

class ScheduleGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var overdueCount: UILabel!
    @IBOutlet weak var allCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell(image: UIImage, title: String, allCount: Int, overdueCount: Int) {
        self.groupImageView.image = image
        self.title.text = title
        self.allCount.text = "\(allCount)"

        if overdueCount > 0 {
            self.overdueCount.isHidden = false
            self.overdueCount.text = "\(overdueCount)"
        } else {
            self.overdueCount.isHidden = true
        }

        if overdueCount == allCount {
            self.allCount.isHidden = true
        } else {
            self.allCount.isHidden = false
        }
    }

}
