//
//  IOSSharingService.swift
//  Taskem
//
//  Created by Wilson on 13.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class IOSSharingService: SharingService {
    func share(text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        controllerToPresentOn?.present(activityVC, animated: true)
    }

    private var controllerToPresentOn: UIViewController? {
        return UIApplication.shared.keyWindow?.taskemViewControllerToPresentOn
    }
}
