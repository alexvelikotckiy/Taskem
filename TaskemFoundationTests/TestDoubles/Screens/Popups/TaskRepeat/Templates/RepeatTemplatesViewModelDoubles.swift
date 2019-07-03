//
//  RepeatTemplatesViewModelDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/16/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class RepeatTemplatesListViewModelMock: RepeatTemplatesListViewModel {
    private var cell: RepeatTemplatesViewModel!
    
    init(rule: RepeatTemplatesViewModel.Rule) {
        self.cell = .init(title: "", icon: "", rule: rule)
        super.init()
    }
    
    override var sections: [RepeatTemplatesSectionViewModel] {
        get {
            return [
                .init(cells: [
                    cell
                    ]
                )
            ]
        }
        set {
            
        }
    }
}
