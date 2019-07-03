//
//  OnboardingSlide.swift
//  Taskem
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class OnboardingSlide: XibFileView {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var waveIcon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    init(header: String, icon: UIImage, theme: AppTheme, wave: UIImage?, description: String) {
        super.init(frame: .zero)
        
        self.title.text = header
        self.icon.image = icon
        self.waveIcon.image = wave
        self.waveIcon.tintColor = theme.onboardingWave
        self.descriptionLabel.attributedText = {
            let string = NSMutableAttributedString(string: description)
            let fullRange = NSRange(location: 0, length: description.count)
            string.addAttributes(
                [
                    .font: UIFont.avenirNext(ofSize: 16, weight: .medium),
                    .foregroundColor: theme.secondTitle,
                    .paragraphStyle: {
                        let style = NSMutableParagraphStyle()
                        style.alignment = .center
                        style.lineHeightMultiple = 1.4
                        return style
                    }()
                ],
                range: fullRange
            )
            return string
        }()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
