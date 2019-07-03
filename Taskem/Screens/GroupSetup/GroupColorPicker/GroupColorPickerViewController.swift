//
//  GroupColorPickerViewController.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupColorPickerViewController: UIViewController, GroupColorPickerView, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!

   // MARK: IBAction

   // MARK: let & var
    var presenter: GroupColorPickerPresenter!
    var viewModel: GroupColorPickerListViewModel = .init()
    weak var delegate: GroupColorPickerViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onViewWillDisappear()
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        tableView.backgroundColor = theme.background
        view.backgroundColor      = theme.background
    }
    
    private func setupUI() {
        setupTable()
        
        observeAppTheme()
    }

    private func setupTable() {
        tableView.register(cell: GroupColorPickerTableCell.self)
    }

    func display(viewModel: GroupColorPickerListViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    func reload(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func scroll(to indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .none, animated: true)
    }
}

extension GroupColorPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onSelect(at: indexPath)
    }
}

extension GroupColorPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupColorPickerTableCell.self)
        cell.setup(viewModel.cell(indexPath))
        return cell
    }
}
