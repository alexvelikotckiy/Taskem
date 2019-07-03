//
//  TaskPopupTagList.swift
//  Taskem
//
//  Created by Wilson on 4/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation
import PainlessInjection

@IBDesignable
class TaskPopupTagList: TagListView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    private func setupView() {
        setupAppearance()
    }
    
    private func setupAppearance() {
        textFont = .avenirNext(ofSize: 14, weight: .medium)
        
        alignment = .left
        enableRemoveButton = true
        removeIconLineWidth = 1
        removeButtonIconSize = 10
        cornerRadius = 12
        
        borderWidth = 0
        tagBackgroundColor = Color.TaskemMain.blue
        borderColor = .clear
        selectedBorderColor = .clear
        
        paddingX = 20
        paddingY = 6
        marginX = 10
        marginY = 10
    }

    func reloadTags(_ models: [TaskPopupTagViewModel]) {
        removeAllTags()
        addTags(models)
    }

    func addTags(_ models: [TaskPopupTagViewModel]) {
        for model in models {
            let newTag = addTag(model.title)
            newTag.backgroundColor = model.color.uicolor
            newTag.enableRemoveButton = model.removable
        }
    }
}
