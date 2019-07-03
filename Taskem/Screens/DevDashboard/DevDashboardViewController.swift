//
//  DevDashboardViewController.swift
//  Taskem
//
//  Created by Wilson on 12/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DevDashboardViewController: UIViewController, DevDashboardView {
   // MARK: IBOutlet

   // MARK: IBAction
    @IBAction func touchResetData(_ sender: Any) {
        delegate?.onTouchResetUserData()
    }
    
    @IBAction func touchClearDefault(_ sender: Any) {
        delegate?.onTouchClearDefaults()
    }
    
    @IBAction func touchClearNotifications(_ sender: Any) {
        delegate?.onTouchClearNotifications()
    }
    
    // MARK: let & var
    var presenter: DevDashboardPresenter!
    var viewModel: DevDashboardViewModel = DevDashboardViewModel()
    weak var delegate: DevDashboardViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.delegate?.onViewWillAppear()
    }

    // MARK: func
    func display(_ viewModel: DevDashboardViewModel) {
    }

}
