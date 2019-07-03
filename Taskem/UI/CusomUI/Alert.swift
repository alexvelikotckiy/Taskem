//
//  Alert.swift
//  Taskem
//
//  Created by Wilson on 26.11.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation

public class Alert {

    public class func displayAlertIn(_ controller: UIViewController, actions: [UIAlertAction], title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        controller.present(alert, animated: true, completion: nil)
    }

    public class func displayActionSheetIn(_ controller: UIViewController, actions: [UIAlertAction], title: String?, message: String?) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        controller.present(actionSheet, animated: true, completion: nil)
    }

    public class func alertDeletion(_ controller: UIViewController, title: String, message: String, _ completion: @escaping ((Bool) -> Void)) {
        let cancelTitle = "Cancel"
        let confirmTitle = "Delete"
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in completion(false) }
        let deleteAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in completion(true) }

        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        controller.present(actionSheet, animated: true, completion: nil)
    }

}
