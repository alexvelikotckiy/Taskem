//
//  PlusButton.swift
//  Taskem
//
//  Created by Wilson on 4/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import DynamicButton

class PlusButton: XibFileView {

    @IBOutlet weak var plus: DynamicButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        plus.bounceButtonOnTouch = true
        plus.strokeColor = .white
        plus.lineWidth = 1
        plus.setStyle(.plus, animated: false)
        
        plus.taskem_cornerRadius = plus.frame.height / 2
        
        layer.shadowPath    = UIBezierPath(roundedRect: rect, cornerRadius: rect.height / 2).cgPath
        layer.shadowColor   = plus.backgroundColor?.cgColor
        layer.shadowRadius  = 5
        layer.shadowOpacity = 0.5
    }
    
    var onTap: (() -> Void)?
    var onLongTap: (() -> Void)?
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        tapGesture.numberOfTapsRequired = 1
        plus.addGestureRecognizer(tapGesture)
        plus.addGestureRecognizer(longGesture)
    }
    
    @objc private func tap() {
        onTap?()
    }
    
    @objc private func longTap(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            onLongTap?()
        }
    }
    
    func show(in controller: UIViewController) {
        controller.view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false

        heightAnchor.constraint(equalToConstant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true

        let guide = controller.view.safeAreaLayoutGuide

        bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -25).isActive = true
        rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -15).isActive = true
    }
}
