//
//  TaskOverviewViewController.swift
//  Taskem
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskOverviewViewController: UIViewController, TaskOverviewView, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IBAction
    
    // MARK: let & var
    var presenter: TaskOverviewPresenter!
    var viewModel: TaskOverviewListViewModel = .init()
    weak var delegate: TaskOverviewViewDelegate?

    private var isTransitioning = false
    private var willViewAppearAfterTransitioning = false
    
    private var wasSetFirstResponder = false
    
    private var shouldFocusTextView: Bool {
        if viewModel.isNewTask {
            if !wasSetFirstResponder {
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
        willViewAppearAfterTransitioning = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resolveFocus()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        setupNavBar()
        
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
    
    @objc private func processShare() {
        delegate?.onTouchShare()
    }

    @objc private func processDelete() {
        delegate?.onTouchDelete()
    }

    @objc private func processEditingCancel() {
        delegate?.onEditingCancel()
    }

    @objc private func processCancel() {
        delegate?.onTouchCancel()
    }
    
    @objc private func processSave() {
        delegate?.onTouchSaveNewTask()
    }

    @objc private func processBack() {
        delegate?.onTouchSaveExistingTask()
    }
    
    private func processRemove(cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        delegate?.onTouchRemoveCell(at: indexPath)
    }
    
    private func resolveFocus() {
        guard shouldFocusTextView else { return }
        let cell = tableView.visibleCells.filter { $0 is TaskNameCell }.first as? TaskNameCell
        cell?.textView.becomeFirstResponder()
        wasSetFirstResponder = true
    }
    
    private func reloadTable() {
        if !isTransitioning, willViewAppearAfterTransitioning { return }
        // reload twice to calculate a textview height
        CATransaction.begin()
        CATransaction.setCompletionBlock(tableView.reloadData)
        tableView.reloadData()
        CATransaction.commit()
    }

    func display(viewModel: TaskOverviewListViewModel) {
        self.viewModel = viewModel
        setEditing(viewModel.editing, animated: true)
        reloadTable()
        setupNavBar()
        setupToolbar()
    }

    func reloadSections(at indexes: IndexSet) {
        tableView.beginUpdates()
        tableView.reloadSections(indexes, with: .automatic)
        tableView.endUpdates()
    }
}

extension TaskOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.onTouchCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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

extension TaskOverviewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel[indexPath] {
        case .name(let value):
            let cell = tableView.dequeueReusableCell(TaskNameCell.self)
            cell.setup(value)
            cell.maxCellHeight = tableView.frame.height / 3
            cell.onTextChanged = { [weak self] cell, text in
                self?.delegate?.onChangeName(text: text)
                self?.navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty || text != ""
            }
            cell.onTouchCheckbox = { [weak self] isOn in self?.delegate?.onChangeCompletion(isOn: isOn) }
            cell.onTextSizeChanged = { [weak self] in
                self?.tableView?.beginUpdates()
                self?.tableView?.endUpdates()
            }
            return cell

        case .project(let value):
            let cell = tableView.dequeueReusableCell(TaskProjectCell.self)
            cell.setup(value)
            return cell
            
        case .dateAndTime(let value):
            let cell = tableView.dequeueReusableCell(TaskInfoExtendedCell.self)
            cell.setup(value)
            cell.onRemove = { [weak self] cell in self?.processRemove(cell: cell) }
            return cell
            
        case .reminders(let value):
            let cell = tableView.dequeueReusableCell(TaskInfoCell.self)
            cell.setup(value)
            cell.onRemove = { [weak self] cell in self?.processRemove(cell: cell) }
            return cell
            
        case .reiteration(let value):
            let cell = tableView.dequeueReusableCell(TaskInfoExtendedCell.self)
            cell.setup(value)
            cell.onRemove = { [weak self] cell in self?.processRemove(cell: cell) }
            return cell

        case .notes(let value):
            let cell = tableView.dequeueReusableCell(TaskNotesCell.self)
            cell.setup(value)
            cell.onTextSizeChanged = { [weak self] in
                self?.tableView?.beginUpdates()
                self?.tableView?.endUpdates()
            }
            return cell
        }
    }
}

extension TaskOverviewViewController {
    func setupUI() {
        if let nav = navigationController as? ExpandNavController {
            nav.onDisappear = { [weak self] in
                self?.delegate?.onViewDidDisappear()
            }
        }
        
        setupTable()
        setupNavBar()
        setupToolbar()
        
        observeAppTheme()
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: TaskNameCell.self)
        tableView.register(cell: TaskProjectCell.self)
        tableView.register(cell: TaskInfoCell.self)
        tableView.register(cell: TaskInfoExtendedCell.self)
        tableView.register(cell: TaskNotesCell.self)
    }
    
    func setupNavBar() {
        switch viewModel.isNewTask {
        case true:
            let save = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(processSave)
            )
            navigationItem.rightBarButtonItem = save
            
            let cancel = UIBarButtonItem(
                barButtonSystemItem: .cancel,
                target: self,
                action: #selector(processCancel)
            )
            navigationItem.leftBarButtonItem = cancel
            
        case false:
            if isEditing {
                let cancel = UIBarButtonItem(
                    barButtonSystemItem: .cancel,
                    target: self,
                    action: #selector(processEditingCancel)
                )
                navigationItem.leftBarButtonItems = [cancel]
                
                navigationItem.rightBarButtonItems = [editButtonItem]
            } else {
                let backButton = UIButton(type: .system)
                backButton.setImage(Icons.icBackChevron.image, for: .normal)
                backButton.setTitle("Back", for: .normal)
                backButton.titleLabel?.font = UIBarButtonItem.appearance()
                    .titleTextAttributes(for: .normal)?
                    .first(where: { $0.key == .font })
                    .map { $0.value } as? UIFont
                backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                
                backButton.addTarget(
                    self,
                    action: #selector(processBack),
                    for: .touchUpInside
                )
                
                let back = UIBarButtonItem(customView: backButton)
                back.width = 100
                
                navigationItem.leftBarButtonItem = back
                
                let share = UIBarButtonItem(
                    image: Icons.icTaskOverviewShare.image,
                    style: .done,
                    target: self,
                    action: #selector(processShare)
                )
                navigationItem.rightBarButtonItems = [editButtonItem, share]
            }
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
}

extension TaskOverviewViewController: ExpandTransitioningAdapter {
    func shouldBeginExpandInteractiveTransitioning() -> Bool {
        if isEditing { return false }

        let top: CGFloat = 0
        let bottom: CGFloat = (tableView.contentSize.height - tableView.frame.size.height).rounded(.towardZero)
        let scrollPosition = tableView.contentOffset.y.rounded(.towardZero)

        // Reached the bottom of the table
        if scrollPosition >= bottom {
            return true
        }
        // Reached the top of the table
        if scrollPosition <= top {
            return true
        }
        return false
    }
    
    func willBeginInteractiveTransitioning() {
        tableView.isScrollEnabled = false
        isTransitioning = true
    }
    
    func didEndInteractiveTransitioning() {
        tableView.isScrollEnabled = true
        isTransitioning = false
        willViewAppearAfterTransitioning = true
    }
}
