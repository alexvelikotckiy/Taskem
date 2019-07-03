//
//  SignUpViewController.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class SignUpViewController: UIViewController, SignUpView, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var nameField: UserBeanTextField!
    @IBOutlet weak var emailField: UserBeanTextField!
    @IBOutlet weak var passwordField: UserBeanTextField!
    
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!

   // MARK: IBAction
    @IBAction func touchSignUp(_ sender: Any) {
        processSignUp()
    }

    @IBAction func textDidChange(_ sender: Any) {
        updateSignButton()
    }
    
    // MARK: let & var
    var presenter: SignUpPresenter!
    var viewModel: SignUpViewModel = SignUpViewModel()
    weak var delegate: SignUpViewDelegate?

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
            nameField.becomeFirstResponder()
            didAppearOnce = true
        }
    }
    
    // MARK: func
    func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        subtitle.textColor   = theme.secondTitle
        
        updateSignButton()
    }

    private func setupUI() {
        observeAppTheme()
        setupNavBar()
        setupTextFields()
    }
    
    private func setupNavBar() {
        guard navigationController != nil else { return }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign in",
            style: .plain,
            target: self,
            action: #selector(processNavigateToSignIn)
        )
    }
    
    private var fields: [UserBeanTextField] {
        return [nameField, emailField, passwordField]
    }
    
    private func setupTextFields() {
        nameField.setup(.name, returnKey: .next)
        emailField.setup(.email, returnKey: .next)
        passwordField.setup(.password, returnKey: .done)
    }
    
    private var isAllFieldsActive: Bool {
        return !fields.compactMap { $0.text?.isEmpty }.contains(true)
    }
    
    private func updateSignButton() {
        signUpButton.isEnabled  = isAllFieldsActive
        signUpButton.alpha      = isAllFieldsActive ? 1 : 0.7
    }
    
    private func processSignUp() {
        unhighlightUI()

        delegate?.onTouchSignUp(
            name:  nameField.text ?? "",
            email: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }

    func display(_ viewModel: SignUpViewModel) {

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

    func postPasswordFailure(_ description: String) {
        postError(description)
        postInvalidField(passwordField)
    }

    func postNameFailure(_ description: String) {
        postError(description)
        postInvalidField(nameField)
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
    
    private func postError(_ description: String) {
        errorLabel.text = description
        errorLabel.isHidden = false
    }
    
    private func unhighlightUI() {
        errorLabel.isHidden = true
        
        nameField.clearValidation()
        emailField.clearValidation()
        passwordField.clearValidation()
    }
    
    @objc private func processNavigateToSignIn() {
        delegate?.onTouchNavigateToSignIn()
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        unhighlightUI()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()

        case emailField:
            passwordField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
        }

        return true
    }
}
