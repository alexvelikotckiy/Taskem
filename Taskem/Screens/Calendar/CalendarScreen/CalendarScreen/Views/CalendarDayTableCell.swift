//
//  CalendarDayCellTableCell.swift
//  Taskem
//
//  Created by Wilson on 7/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit

class CalendarDayTableCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.register(cell: CalendarTaskTableCell.self)
        tableView.register(cell: CalendarEventTableCell.self)
        tableView.register(cell: CalendarTodayTimeTableCell.self)
        tableView.register(cell: CalendarFreeDayTableCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CalendarDayTableCell: UITableViewDelegate {
    
}

extension CalendarDayTableCell: UITableViewDataSource {
    
}
