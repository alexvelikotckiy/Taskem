//
//  SelectableView.swift
//  Taskem
//
//  Created by Wilson on 15.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

@IBDesignable
class SelectableView: UIView, ThemeObservable {

    @IBInspectable var selectionColor: UIColor = AppTheme.current.cellHighlight
    @IBInspectable var defaultColor: UIColor = UIColor.clear
    
    var selectAction: ((SelectableView) -> Void)?
    private let control: UIControl

    required init?(coder aDecoder: NSCoder) {
        control = UIControl(frame: .zero)
        super.init(coder: aDecoder)
        control.frame = bounds
        addSubview(control)
        setupControlEvents()
    }

    override init(frame: CGRect) {
        control = UIControl(frame: frame)
        super.init(frame: frame)
        addSubview(control)
        setupControlEvents()
    }

    public func applyTheme(_ theme: AppTheme) {
        selectionColor = theme.cellHighlight
    }
    
    private func setupControlEvents() {
        control.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
        control.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        control.addTarget(self, action: #selector(onTouchUpOutside), for: .touchUpOutside)
        control.addTarget(self, action: #selector(onTouchUpOutside), for: .touchCancel)
        control.addTarget(self, action: #selector(onTouchUpOutside), for: .touchDragExit)
        control.addTarget(self, action: #selector(onTouchUpOutside), for: .touchDragOutside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        control.frame = bounds
    }

    @objc private func onTouchDown() {
        backgroundColor = selectionColor
    }

    @objc private func onTouchUpOutside() {
        runDeselectAnimation()
    }

    @objc private func onTouchUpInside() {
        runDeselectAnimation()
        selectAction?(self)
    }

    func runDeselectAnimation(delay: TimeInterval = 0) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.backgroundColor = self.defaultColor
        }
        animator.startAnimation()
    }

}
