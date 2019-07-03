//
//  XibFileView.swift
//  Taskem
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class XibFileView: UIView {
    private(set) var rootView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        setupUI()
    }

    private func setupUI() {
        if let view = rootView {
            view.removeFromSuperview()
        }

        rootView = loadContentView()
        rootView.frame = bounds
        rootView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rootView)
        addConstraints(to: rootView, matchingFrameOf: self)
        setNeedsLayout()
        setupView()
    }

    private func addConstraints(to rootView: UIView, matchingFrameOf other: UIView) {
        addConstraints([
            NSLayoutConstraint(
                item: rootView,
                attribute: .left,
                relatedBy: .equal,
                toItem: other,
                attribute: .left,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rootView,
                attribute: .right,
                relatedBy: .equal,
                toItem: other,
                attribute: .right,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rootView,
                attribute: .top,
                relatedBy: .equal,
                toItem: other,
                attribute: .top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: rootView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: other,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            )
            ])
    }

    func setupView() {

    }

    internal func loadContentView() -> UIView {
        let nib = contentViewNib()
        let list = nib.instantiate(withOwner: self)
        if let view = list.first as? UIView {
            return view
        } else {
            fatalError("There is no view in \(nib).")
        }
    }

    internal func contentViewNib() -> UINib {
        let bundle = Bundle(for: type(of: self))
        return UINib(nibName: String(describing: type(of: self)), bundle: bundle)
    }

}
