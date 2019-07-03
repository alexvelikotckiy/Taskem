//
//  SettingsViewController.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class SettingsViewController: UITableViewController, SettingsView, ThemeObservable {
   // MARK: IBOutlet
    
   // MARK: IBAction

   // MARK: let & var
    var presenter: SettingsPresenter!
    var viewModel: SettingsListViewModel = .init()
    weak var delegate: SettingsViewDelegate?

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
        tableView.backgroundColor = theme.background
        tableView.separatorColor = theme.separatorSecond
        
        navigationController?.view.backgroundColor = theme.background
    }
    
    func display(_ viewModel: SettingsListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
    
    func reloadSections(at indexes: IndexSet, with animation: UITableView.RowAnimation) {
        tableView.beginUpdates()
        tableView.reloadSections(indexes, with: animation)
        tableView.endUpdates()
    }
    
    func reloadRows(at indexes: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.beginUpdates()
        tableView.reloadRows(at: indexes, with: animation)
        tableView.endUpdates()
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel[section].title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont.avenirNext(ofSize: 16, weight: .medium)
        header.textLabel?.textColor = AppTheme.current.firstTitle
    }
}

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureAndCreateCell(at: indexPath)
    }
}

extension SettingsViewController {
    func setupUI() {
        setupTable()
        setupNavBar()
        
        observeAppTheme()
    }
    
    func setupTable() {
        tableView.register(cell: SettingsTableCell.self)
        tableView.register(cell: SettingsTimePickerTableCell.self)
    }
    
    func setupNavBar() {
        
    }
    
    @discardableResult
    func configureAndCreateCell(at index: IndexPath) -> UITableViewCell {
        switch viewModel[index] {
        case .simple(let model):
            let cell = tableView.dequeueReusableCell(SettingsTableCell.self)
            cell.setup(model)
            return cell
            
        case .time(let model):
            if model.extended {
                let cell = tableView.dequeueReusableCell(SettingsTimePickerTableCell.self)
                cell.setup(model)
                cell.onChangeTime = { [weak self] cell in
                    guard let index = self?.tableView.indexPath(for: cell) else { return }
                    self?.delegate?.onChangeTime(at: index, date: cell.timePicker.date)
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(SettingsTableCell.self)
                cell.setup(model)
                return cell
            }
        }
    }
}
