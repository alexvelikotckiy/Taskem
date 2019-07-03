//
//  UserProfileViewController.swift
//  Taskem
//
//  Created by Wilson on 25/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class UserProfileViewController: UITableViewController, UserProfileView, ThemeObservable {
    
   // MARK: IBOutlet

   // MARK: IBAction

   // MARK: let & var
    var presenter: UserProfilePresenter!
    var viewModel: UserProfileListViewModel = UserProfileListViewModel()
    weak var delegate: UserProfileViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }

    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
    }
    
    func display(_ viewModel: UserProfileListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func displaySpinner(_ isVisible: Bool) {
        if isVisible {
            displaySpinner()
        } else {
            removeSpinner()
        }
    }
}

extension UserProfileViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return viewModel.sections[section].footer
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.avenirNext(ofSize: 16, weight: .medium)
        header.textLabel?.textColor = AppTheme.current.firstTitle
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.font = UIFont.avenirNext(ofSize: 13, weight: .medium)
        footer.textLabel?.textColor = AppTheme.current.thirdTitle
    }
}

extension UserProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserProfileTableCell.self)
        cell.setup(viewModel[indexPath])
        return cell
    }
}

extension UserProfileViewController {
    func setupUI() {
        setupTable()
        
        observeAppTheme()
    }
    
    func setupTable() {
        tableView.register(cell: UserProfileTableCell.self)
    }
}
