//
//  AlertView.swift
//  Taskem
//
//  Created by Wilson on 4/1/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit

@IBDesignable
class AlertView: SelectableView {

    @IBOutlet weak var title: UILabel!

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    class func newView() -> AlertView {
        let nib = UINib(nibName: "AlertView", bundle: nil)
        if let itemView = nib.instantiate(withOwner: nil, options: nil).first as? AlertView {
            return itemView
        }
        fatalError("Error")
    }

    override func runDeselectAnimation(delay: TimeInterval) {
        self.fadeOut(1, delay: 0) { _ in
            self.removeFromSuperview()
        }
    }

    class func post(in controller: UIViewController, message: String) {
        let alert = AlertView.newView()
        alert.title.text = message
        alert.post(in: controller)
    }

    func post(in controller: UIViewController) {
        controller.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false

        let margins = controller.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: margins.topAnchor),
            self.leftAnchor.constraint(equalTo: margins.leftAnchor),
            self.rightAnchor.constraint(equalTo: margins.rightAnchor),
            self.heightAnchor.constraint(equalToConstant: 25)
            ])

        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.fadeOut(1, delay: 0) { _ in
                self.removeFromSuperview()
            }
        }
    }

}
