//
//  SignInViewController.swift
//  Taskem
//
//  Created by Wilson on 14/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import PainlessInjection

class SignInViewController: UIViewController, SignInView, ThemeObservable {
    
   // MARK: IBOutlet
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var emailField: UserBeanTextField!
    @IBOutlet weak var passField: UserBeanTextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

   // MARK: IBAction
    @IBAction func touchSignIn(_ sender: Any) {
        processSignIn()
    }

    @IBAction func touchForgotPassword(_ sender: Any) {
        delegate?.onTouchResetPassword(email: emailField.text ?? "")
    }
    
    @IBAction func textDidChange(_ sender: Any) {
        updateSignInButton()
    }

    // MARK: let & var
    var presenter: SignInPresenter!
    var viewModel: SignInViewModel = SignInViewModel()
    weak var delegate: SignInViewDelegate?

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
        
        updateSignInButton()
    }
    
    private func setupUI() {
        setupNavBar()
        setupTextFields()
        observeAppTheme()
    }
    
    private func setupTextFields() {
        emailField.setup(.email, returnKey: .next)
        passField.setup(.password, returnKey: .done)
    }
    
    private func updateSignInButton() {
        signInButton.isEnabled  = isAllFieldsActive
        signInButton.alpha      = isAllFieldsActive ? 1 : 0.7
    }
    
    private var isAllFieldsActive: Bool {
        return !fields.compactMap { $0.text?.isEmpty }.contains(true)
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
        postInvalidField(passField)
    }

    func postFailure(_ description: String) {
        postError(description)
    }

    func display(_ viewModel: SignInViewModel) {
        
    }
    
    private var fields: [UserBeanTextField] {
        return [emailField, passField]
    }
    
    private func processSignIn() {
        unhighlightUI()
        
        delegate?.onTouchSignIn(
            email: emailField.text ?? "",
            password: passField.text ?? ""
        )
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
    
    private func unhighlightUI() {
        errorLabel.isHidden = true
        
        emailField.clearValidation()
        passField.clearValidation()
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
        delegate?.onTouchNavigateSignUp()
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        unhighlightUI()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passField.becomeFirstResponder()

        default:
            textField.resignFirstResponder()
            processSignIn()
        }

        return true
    }
}
