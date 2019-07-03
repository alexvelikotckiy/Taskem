//
//  TaskPopupViewController.swift
//  Taskem
//
//  Created by Wilson on 12/11/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import UIKit
import TaskemFoundation
import DynamicButton

class TaskPopupViewController: UIViewController, TaskPopupView, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var textView: GrowingTextView!
    
    @IBOutlet weak var plusButton: DynamicButton!
    
    @IBOutlet weak var separatorFirst: UIView!
    @IBOutlet weak var separatorSecond: UIView!
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    
    @IBOutlet weak var tagList: TaskPopupTagList!
    @IBOutlet weak var tagListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dismissalView: SelectableView!
    
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
   // MARK: IBAction
    @IBAction func touchAdd(_ sender: Any) {
        textView.text.isEmpty ? delegate?.onTouchCancel() : processAdd()
    }

    @IBAction func touchGroup(_ sender: Any) {
        delegate?.onTouchProject()
    }

    @IBAction func touchCalendar(_ sender: Any) {
        delegate?.onTouchCalendar()
    }

    @IBAction func touchRepeat(_ sender: Any) {
        delegate?.onTouchRepeat()
    }

    @IBAction func touchReminder(_ sender: Any) {
        delegate?.onTouchReminder()
    }

    // MARK: let & var
    var presenter: TaskPopupPresenter!
    var viewModel: TaskPopupViewModel = .init()
    weak var delegate: TaskPopupViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
        delegate?.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textView.resignFirstResponder()
    }

    override func reloadInputViews() {
        super.reloadInputViews()
        
        textView.text = viewModel.name
        textView.returnKeyType = .default
        textView.reloadInputViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        textView.placeholderColor       = theme.textViewPlaceholder
        textView.textColor              = theme.textView
        
        view.backgroundColor            = theme.background
        
        separatorFirst.backgroundColor  = theme.separatorSecond
        separatorSecond.backgroundColor = theme.separatorSecond
        
        controlButtons.forEach {
            $0.tintColor                = theme.iconTint
        }
        
        calendarButton.setImage(
            Icons.icDateCalendar.image.taskem_tinted(using: theme.iconHighlightedTint),
            for: .highlighted
        )
        listButton.setImage(
            Icons.icList.image.taskem_tinted(using: theme.iconHighlightedTint),
            for: .highlighted
        )
        repeatButton.setImage(
            Icons.icRepeat.image.taskem_tinted(using: theme.iconHighlightedTint),
            for: .highlighted
        )
        reminderButton.setImage(
            Icons.icReminder.image.taskem_tinted(using: theme.iconHighlightedTint),
            for: .highlighted
        )
    }
    
    private var controlButtons: [UIButton] {
        return [
            calendarButton,
            listButton,
            repeatButton,
            reminderButton
        ]
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? Double else { return }
        
        keyboardHeight.constant = keyboardSize.height
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupUI() {
        observeAppTheme()
        observeKeyboard()
        
        setupPlus()
        setupDismissalView()
    }
    
    private func setupDismissalView() {
        dismissalView.selectAction = { [weak self] _ in
            self?.view.endEditing(true)
            self?.delegate?.onTouchCancel()
        }
    }
    
    private func setupPlus() {
        plusButton.taskem_cornerRadius = plusButton.frame.height / 2
        plusButton.bounceButtonOnTouch = true
        plusButton.strokeColor = .white
        plusButton.lineWidth = 1
    }
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private var isNothingToAdd: Bool {
        return textView.text.isEmpty
    }
    
    private func reloadPlus() {
        if shouldReloadPlus() {
            plusButton.backgroundColor = isNothingToAdd ? Color.TaskemMain.red : Color.TaskemMain.blue
            plusButton.setStyle(resolvePlusStyle(), animated: true)
        }
        
        textView.returnKeyType = isNothingToAdd ? .default : .next
        textView.reloadInputViews()
    }
    
    private func shouldReloadPlus() -> Bool {
        return plusButton.style != resolvePlusStyle()
    }
    
    private func resolvePlusStyle() -> DynamicButton.Style {
        return isNothingToAdd ? .close : .plus
    }

    private func reloadTagView() {
        tagList.reloadTags(viewModel.tags)
        tagListHeight.constant = tagList.intrinsicContentSize.height
        view.updateConstraints()
    }
    
    private func processAdd() {
        delegate?.onTouchAdd()
        reload()
    }
    
    func display(_ viewModel: TaskPopupViewModel) {
        self.viewModel = viewModel
        reload()
    }
    
    func reload() {
        reloadInputViews()
        reloadTagView()
        reloadPlus()
    }
}

extension TaskPopupViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        delegate?.onChangeName(text: textView.text)
        reloadPlus()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            if textView.text.isEmpty {
                delegate?.onTouchCancel()
            } else {
                processAdd()
            }
            return false
        }
        return true
    }
}

extension TaskPopupViewController: GrowingTextViewDelegate {

    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}

extension TaskPopupViewController: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let index = sender.tagViews.firstIndex(where: { $0 == tagView }) else { return }
        delegate?.onTouchRemoveTag(at: index)
    }
}
