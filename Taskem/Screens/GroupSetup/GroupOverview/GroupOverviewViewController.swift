//
//  GroupOverviewViewController.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class GroupOverviewViewController: UIViewController, GroupOverviewView, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
   // MARK: IBAction
    
   // MARK: let & var
    var presenter: GroupOverviewPresenter!
    var viewModel: GroupOverviewListViewModel = .init()
    weak var delegate: GroupOverviewViewDelegate?

    private var canSetFirstResponder = false
    private var wasSetFirstResponder = false

    private var shouldFocusTextView: Bool {
        if viewModel.isNewList {
            if canSetFirstResponder, !wasSetFirstResponder {
                return true
            }
        }
        return false
    }

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resolveFocus()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
        if editing {
            delegate?.onEditingStart()
        } else {
            delegate?.onEditingEnd()
        }
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        navigationController?.view.backgroundColor = theme.background
        tableView.backgroundColor                  = theme.background
        view.backgroundColor                       = theme.background
    }
    
    @objc private func processSave() {
        delegate?.onTouchSave()
    }

    @objc private func processCancel() {
        delegate?.onTouchCancel()
    }

    @objc private func processDelete() {
        delegate?.onTouchDelete()
    }
    
    private func resolveFocus() {
        guard shouldFocusTextView else { return }
        let cell = tableView.visibleCells.filter { $0 is GroupOverviewNameCell }.first as? GroupOverviewNameCell
        cell?.textView.becomeFirstResponder()
        wasSetFirstResponder = true
    }
    
    func display(viewModel: GroupOverviewListViewModel) {
        self.viewModel = viewModel
        isEditing = viewModel.editing
        reloadTable()
        setupNavBar()
        setupToolbar()
    }

    func reloadTable() {
        // reload twice to calculate a textview height
        CATransaction.begin()
        CATransaction.setCompletionBlock(tableView.reloadData)
        tableView.reloadData()
        CATransaction.commit()
    }
}

extension GroupOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.onTouchCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension GroupOverviewViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel[indexPath] {
        case .name(let value):
            let cell = tableView.dequeueReusableCell(GroupOverviewNameCell.self)
            let placeholder = viewModel.isNewList ? "Enter a new list name..." : "Enter a list name..."
            cell.setup(value, placeholder: placeholder)
            cell.onTextChanged = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.onChangeName(text: $0)
                if strongSelf.viewModel.isNewList {
                    strongSelf.navigationItem.rightBarButtonItem?.isEnabled = !$0.isEmpty
                }
            }
            cell.onTextSizeChanged = { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                self?.canSetFirstResponder = true
            }
            return cell

        case .isDefault(let value):
            let cell = tableView.dequeueReusableCell(GroupOverviewIsDefaultCell.self)
            cell.setup(value)
            cell.onSwitch = { [weak self] in self?.delegate?.onChangeDefault(isOn: $0) }
            return cell

        case .icon(let value):
            let cell = tableView.dequeueReusableCell(GroupOverviewIconCell.self)
            cell.setup(value)
            return cell

        case .color(let value):
            let cell = tableView.dequeueReusableCell(GroupOverviewColorCell.self)
            cell.setup(value)
            return cell
            
        case .created(let value):
            let cell = tableView.dequeueReusableCell(GroupOverviewCreationCell.self)
            cell.setup(value)
            return cell
        }
    }
}

extension GroupOverviewViewController {
    func setupUI() {
        setupNavBar()
        setupTable()
        setupToolbar()
        
        observeAppTheme()
    }
    
    func setupNavBar() {
        let cancel = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(processCancel)
        )
        navigationItem.leftBarButtonItem = cancel
        
        switch viewModel.isNewList {
        case true:
            let save = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(processSave)
            )
            navigationItem.rightBarButtonItem = save
            
        case false:
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
    
    func setupToolbar() {
        if viewModel.canDelete {
            let deleteList = UIBarButtonItem(
                title: "Delete",
                style: .done,
                target: self,
                action: #selector(processDelete)
            )
            deleteList.setTitleTextAttributes(
                [
                    NSAttributedString.Key.foregroundColor: AppTheme.current.redTitle,
                    NSAttributedString.Key.font: UIFont.avenirNext(ofSize: 16, weight: .demiBold)
                ],
                for: .normal
            )
            
            let space = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            toolbarItems = [space, deleteList, space]
            navigationController?.isToolbarHidden = false
        }
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: GroupOverviewNameCell.self)
        tableView.register(cell: GroupOverviewIsDefaultCell.self)
        tableView.register(cell: GroupOverviewIconCell.self)
        tableView.register(cell: GroupOverviewColorCell.self)
        tableView.register(cell: GroupOverviewCreationCell.self)
    }
}
