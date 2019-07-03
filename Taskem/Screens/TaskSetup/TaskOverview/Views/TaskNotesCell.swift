//
//  TaskNotesTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 10.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskNotesCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
        
        textViewHeight.constant = maxCellHeight
        textView.isScrollEnabled = true
        textView.delegate = self
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor             = .clear
        contentView.backgroundColor = .clear
        
        textView.textColor          = theme.textView
        textView.placeholderColor   = theme.textViewPlaceholder
        subtitle.textColor          = theme.fifthTitle
        icon.tintColor              = theme.iconTint
    }
    
    private let maxCellHeight: CGFloat = 150
    private let minCellHeight: CGFloat = 40
    
    var onTextSizeChanged: (() -> Void)?

    func setup(_ viewModel: TaskOverviewViewModel.Notes) {
        textView.text = viewModel.title
        textView.placeholder = viewModel.placeholder as NSString
        textView.delegate?.textViewDidChange?(textView)
        icon.image = viewModel.icon.image
        subtitle.text = viewModel.subtitle
        
        subtitle.letterSpace = 1.5
    }
}

extension TaskNotesCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        onTextSizeChanged?()
        let oldHeight = textViewHeight.constant
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = newSize.height > maxCellHeight ? maxCellHeight : CGFloat.maximum(minCellHeight, newSize.height)
        
        if oldHeight != newHeight {
            textView.isScrollEnabled = newHeight == maxCellHeight
            textViewHeight.constant = newHeight
            onTextSizeChanged?()
        }
    }
}
