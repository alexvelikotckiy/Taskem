//
//  TaskemToolbar.swift
//  Taskem
//
//  Created by Wilson on 7/23/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

@IBDesignable
class TaskemToolbar: XibFileView {
    @IBOutlet weak var toolbar: UIToolbar!
    
    func setToolbar(items: [UIBarButtonItem]) {
        toolbar.items = items
        layoutSubviews()
    }
    
    func addTo(_ view: UIView) {
        view.addSubview(self)
        addSizeConstraints()
        addPositionConstraints(in: view)
        sizeToFit()
    }
    
    private func addSizeConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),
            ])
    }
    
    private func addPositionConstraints(in view: UIView) {
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            rightAnchor.constraint(equalTo: margins.rightAnchor),
            leftAnchor.constraint(equalTo: margins.leftAnchor)
            ])
    }
}
