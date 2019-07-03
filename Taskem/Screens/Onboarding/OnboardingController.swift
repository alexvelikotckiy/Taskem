//
//  OnboardingController.swift
//  Taskem
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation
import CHIPageControl
import PainlessInjection

class OnboardingController: UIViewController, ThemeObservable {
    
    // MARK: IBOutlet
    @IBOutlet weak var slideView: SliderView!
    
    @IBOutlet weak var stepView: UIStackView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var controlPage: CHIPageControlPaprika!
    
    @IBOutlet weak var continueView: UIView!
    @IBOutlet weak var continueAdjustView: UIView!
    
    // MARK: IBAction
    @IBAction func processNext(_ sender: Any) {
        slideView.setCurrentSlide(slideView.currentSlide + 1, animated: true)
    }

    @IBAction func processEndOnboarding(_ sender: Any) {
        endOnboarding()
    }
    
    // MARK: class func
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not available. Use the appropriate init method.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slideView.sliderDelegate = self

        setupUI()
    }

    // MARK: func
    private func setupUI() {
        observeAppTheme()
        setupSliders()
    }
    
    func applyTheme(_ theme: AppTheme) {
        slides = produceSlides(theme)
        
        controlPage.currentPageTintColor    = theme.onboardingSlider
        controlPage.tintColor               = theme.onboardingSlider
        
        view.backgroundColor                = theme.background
        
        skipButton.titleLabel?.textColor    = theme.thirdTitle
    }
    
    private func stopOnboarding() {
        slideView.isUserInteractionEnabled = false
        
        continueAdjustView.alpha = 0
        continueView.alpha = 0
        continueAdjustView.isHidden = false
        continueView.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.continueAdjustView.alpha = 1
            self.continueView.alpha = 1
            self.stepView.alpha = 0
        }
        animator.startAnimation()
    }
    
    private func endOnboarding() {
        let vc: LogInViewController = Container.get()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupSliders() {
        controlPage.inactiveTransparency = 0
        controlPage.padding = 7
        controlPage.numberOfPages = slides.count
        controlPage.radius = 5
        controlPage.borderWidth = 1
    }
    
    private var currentSlideIsTheLastOne: Bool {
        return slideView.currentSlide == slides.count - 1
    }

    private var slides: [OnboardingSlide] = []
    
    private func produceSlides(_ theme: AppTheme) -> [OnboardingSlide] {
        return [
            OnboardingSlide(
                header: "ORGANIZE YOUR LIFE",
                icon: .onboarding1(theme),
                theme: theme,
                wave: Icons.icWave1.image,
                description:
                """
                Keep you mind focused on stuff that matter and never forget a thing.
                """
            ),
            OnboardingSlide(
                header: "GET DONE STUFF EASILY",
                icon: .onboarding2(theme),
                theme: theme,
                wave: Icons.icWave2.image,
                description:
                """
                Use lists to collect and manage your ideas, plans and goals.
                """
            ),
            OnboardingSlide(
                header: "SIMPLIFY YOUR SCHEDULE",
                icon: .onboarding3(theme),
                theme: theme,
                wave: Icons.icWave3.image,
                description:
                """
                Get organized your tasks with calendar and get rid of lack of time.
                """
            )
        ]
    }
}

extension OnboardingController: SliderViewDelegate {
    func sliderViewNumberOfSlideds(_ view: SliderView) -> Int {
        return slides.count
    }
    
    func sliderView(_ view: SliderView, slideAt index: Int) -> UIView {
        return slides[index]
    }
    
    func sliderView(_ view: SliderView, didChangeSlide index: Int) {
        controlPage.set(progress: index, animated: true)
        
        if currentSlideIsTheLastOne {
            stopOnboarding()
        }
    }
}
