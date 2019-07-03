//
//  LogInViewController.swift
//  Taskem
//
//  Created by Wilson on 09/06/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import GoogleSignIn
import PainlessInjection

class LogInViewController: UIViewController, LogInView, ThemeObservable {
    
   // MARK: IBOutlet
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var anononymousButton: UIButton!
    @IBOutlet weak var sliderView: SliderView!
    
   // MARK: IBAction
    @IBAction func touchGoogleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        displaySpinner(true)
    }
    
    @IBAction func touchEmailSignUp(_ sender: Any) {
        delegate?.onTouchSignUp()
    }

    @IBAction func touchSignIn(_ sender: Any) {
        delegate?.onTouchSignIn()
    }

    @IBAction func touchAnonymousSignIn(_ sender: Any) {
        delegate?.onTouchAnonymousSignIn()
    }

    // MARK: let & var
    var presenter: LogInPresenter!
    var viewModel: LogInViewModel = .init()
    weak var delegate: LogInViewDelegate?

    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        delegate?.onViewWillAppear()
    }

    // MARK: func
    private func setupUI() {
        setupTheme()
        
        sliderView.isUserInteractionEnabled = false
        sliderView.sliderDelegate = self
    }
    
    private func setupTheme() {
        let themeManager: ThemeManager = Container.get()
        themeManager.addAndEmitObserver(self)
    }
    
    func applyTheme(_ theme: AppTheme) {
        slides = produceSlides(theme)
        
        view.backgroundColor = theme.background
        
        anononymousButton.titleLabel?.textColor = theme.thirdTitle
    }
    
    func displaySpinner(_ isVisible: Bool) {
        if isVisible {
            displaySpinner()
        } else {
            removeSpinner()
        }
    }

    func display(_ viewModel: LogInViewModel) {
        anononymousButton.setTitle(viewModel.anonymousSignInTitle, for: .normal)
    }
    
    private var slides: [OnboardingSlide] = []
    
    private func produceSlides(_ theme: AppTheme) -> [OnboardingSlide] {
        return [
            OnboardingSlide(
                header: "",
                icon: .init(),
                theme: theme,
                wave: nil,
                description: ""
            )
        ]
    }
}

extension LogInViewController: SliderViewDelegate {
    func sliderViewNumberOfSlideds(_ view: SliderView) -> Int {
        return 1
    }
    
    func sliderView(_ view: SliderView, slideAt index: Int) -> UIView {
        return slides[index]
    }
    
    func sliderView(_ view: SliderView, didChangeSlide index: Int) {
        
    }
}

extension LogInViewController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        displaySpinner(false)
    }
}
