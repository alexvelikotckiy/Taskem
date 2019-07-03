//
//  NotificationSoundPickerViewController.swift
//  Taskem
//
//  Created by Wilson on 24/07/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class NotificationSoundPickerViewController: UITableViewController, NotificationSoundPickerView, ThemeObservable {
   // MARK: IBOutlet

   // MARK: IBAction

   // MARK: let & var
    var presenter: NotificationSoundPickerPresenter!
    var viewModel: NotificationSoundPickerListViewModel = .init()
    weak var delegate: NotificationSoundPickerViewDelegate?

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
    
    func display(_ viewModel: NotificationSoundPickerListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    func reload(at index: IndexPath) {
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
}

extension NotificationSoundPickerViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath)
    }
}

extension NotificationSoundPickerViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createAndConfigure(at: indexPath)
    }
}

extension NotificationSoundPickerViewController {
    func setupUI() {
        setupTable()
        observeAppTheme()
    }
    
    func setupTable() {
        tableView.register(cell: NotificationSoundPickerTableCell.self)
    }
    
    func createAndConfigure(at index: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(NotificationSoundPickerTableCell.self)
        cell.setup(viewModel[index])
        return cell
    }
}
