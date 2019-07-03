//
//  ScheduleTableViewHeader.swift
//  Taskem
//
//  Created by Wilson on 11.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import UIKit
import ExpyTableView

protocol ScheduleTableHeaderDelegete: class {
    func touchHeaderAction(status: ScheduleStatus, section: Int)
}

class ScheduleTableViewHeader: UITableViewCell, ExpyTableViewHeaderCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    weak var delegateHeader: ScheduleTableHeaderDelegete?
    var section = 0
    var rows = 0

    var isExpanded: Bool = false {
        didSet {

        }
    }

    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        switch state {
        case .willExpand:
            break
        case .willCollapse:
            break
        case .didExpand, .didCollapse:
            self.isExpanded = !self.isExpanded
        }
    }

    func setHeader(with model: ScheduleSectionViewModel, section: Int, isExpanded: Bool) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.title.text = model.title
        self.section = section
        self.isExpanded = isExpanded
    }

//    private func updateActionBtn() {
//        if self.isExpanded {
//            self.circleView.isHidden = false
//            self.circleView.layer.backgroundColor = UIColor.white.cgColor
//            self.actionBtn.setTitleColor(UIColor.customBackground(), for: .normal)
//            self.actionBtn.setImage(nil, for: .normal)
//            self.actionBtn.setTitle("\(self.rows)", for: .normal)
//        } else {
//            self.circleView.isHidden = true
//            self.actionBtn.setTitle(nil, for: .normal)
//            let title = self.name.text?.lowercased()
//            let status = ScheduleStatus.strToStatus(strStatus: title!)
//
//            switch status {
//            case .overdue:
//                let send = UIImage(named: "send_icon")
//                self.actionBtn.setImage(send, for: .normal)
//            case .complete:
//                let delete = UIImage(named: "delete_icon")
//                self.actionBtn.setImage(delete, for: .normal)
//            default:
//                let add = UIImage(named: "add_icon")
//                self.actionBtn.setImage(add, for: .normal)
//
//            }
//        }
//    }

}
