//
//  PasswordResetViewController.swift
//  Taskem
//
//  Created by Wilson on 30/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class PasswordResetViewController: UIViewController, PasswordResetView, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var emailField: UserBeanTextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!

    // MARK: IBAction
    @IBAction func touchReset(_ sender: Any) {
        processReset()
    }

    @IBAction func textDidChange(_ sender: Any) {
        updateResetButton()
    }
    
    // MARK: let & var
    var presenter: PasswordResetPresenter!
    var viewModel: PasswordResetViewModel = .init()
    weak var delegate: PasswordResetViewDelegate?

    private var didAppearOnce = false
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        delegate?.onViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didAppearOnce {
            emailField.becomeFirstResponder()
            didAppearOnce = true
        }
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        subtitle.textColor   = theme.secondTitle
        
        updateResetButton()
    }
    
    private func setupUI() {
        observeAppTheme()
        setupNavBar()
        setupTextFields()
    }
    
    private func setupTextFields() {
        emailField.setup(.email, returnKey: .next)
    }
    
    private func updateResetButton() {
        resetButton.isEnabled  = isAllFieldsActive
        resetButton.alpha      = isAllFieldsActive ? 1 : 0.7
    }
    
    private var fields: [UserBeanTextField] {
        return [emailField]
    }
    
    private var isAllFieldsActive: Bool {
        return !fields.compactMap { $0.text?.isEmpty }.contains(true)
    }
    
    private func setupNavBar() {
        guard navigationController != nil else { return }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign up",
            style: .plain,
            target: self,
            action: #selector(processNavigateToSignUp)
        )
    }

    @objc private func processNavigateToSignUp() {
        delegate?.onTouchNavigateToSignUp()
    }
    
    private func unhighlightUI() {
        errorLabel.isHidden = true
        
        emailField.clearValidation()
    }
    
    private func postError(_ description: String) {
        errorLabel.text = description
        errorLabel.isHidden = false
    }
    
    private func postInvalidField(_ textField: UserBeanTextField) {
        for field in fields {
            if field == textField {
                field.isValid(false)
                return
            }
            field.isValid(true)
        }
    }
    
    private func processReset() {
        unhighlightUI()
        
        delegate?.onTouchReset(email: emailField.text ?? "")
    }
    
    func display(_ viewModel: PasswordResetViewModel) {
        emailField.text = viewModel.email
        updateResetButton()
    }
    
    func displaySpinner(_ isVisible: Bool) {
        if isVisible {
            displaySpinner()
        } else {
            removeSpinner()
        }
    }
    
    func postEmailFailure(_ description: String) {
        postError(description)
        postInvalidField(emailField)
    }
    
    func postFailure(_ description: String) {
        postError(description)
    }
}

extension PasswordResetViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        unhighlightUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
