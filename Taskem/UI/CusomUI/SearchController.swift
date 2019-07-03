//
//  SearchController.swift
//  Taskem
//
//  Created by Wilson on 7/26/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

class SearchController: UISearchController {
    override func viewWillDisappear(_ animated: Bool) {
        // to avoid black screen when switching tabs while searching
        isActive = false
    }
}
