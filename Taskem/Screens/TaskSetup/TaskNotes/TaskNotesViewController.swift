//
//  TaskNotesViewController.swift
//  Taskem
//
//  Created by Wilson on 13/12/2017.
//  Copyright © 2017 WIlson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskNotesViewController: UIViewController, TaskNotesView, ThemeObservable {

    // MARK: IBOutlet
    @IBOutlet weak var textView: RSKPlaceholderTextView!

    // MARK: IBAction

    // MARK: let & var
    var presenter: TaskNotesPresenter!
    var viewModel: TaskNotesViewModel = .init()
    weak var delegate: TaskNotesViewDelegate?

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
        textView.resignFirstResponder()
    }

    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        textView.textColor = theme.textView
        textView.placeholderColor = theme.textViewPlaceholder
    }
    
    private func setupUI() {
        textView.delegate = self
        
        setupNavbar()
        setHideKeyboardHandler()
        
        observeAppTheme()
    }
    
    private func setupNavbar() {
        let clear = UIBarButtonItem(
            title: "Clear",
            style: .done,
            target: self,
            action: #selector(processClear)
        )
        
        navigationItem.rightBarButtonItem = clear
    }
    
    @objc private func processClear() {
        textView.text = ""
        delegate?.onUpdate(notes: "")
    }
    
    private func setHideKeyboardHandler() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func display(viewModel: TaskNotesViewModel) {
        self.viewModel = viewModel
        textView.text = viewModel.notes
        DispatchQueue.main.async {
            self.textView.becomeFirstResponder()
        }
    }
}

extension TaskNotesViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        delegate?.onUpdate(notes: textView.text)
        return true
    }
}
