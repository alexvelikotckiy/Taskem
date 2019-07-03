//
//  GroupOverviewTableCell.swift
//  Taskem
//
//  Created by Wilson on 3/21/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import UIKit
import TaskemFoundation

class GroupOverviewNameCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
        
        textViewHeight.constant = maxCellHeight
        textView.isScrollEnabled = true
        textView.delegate = self
        
        textView.textContainer.lineFragmentPadding = 0
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        textView.isUserInteractionEnabled = editing
    }
    
    func applyTheme(_ theme: AppTheme) {
        backgroundColor             = theme.background
        contentView.backgroundColor = theme.background
        
        textView.textColor          = theme.textView
        textView.placeholderColor   = theme.textViewPlaceholder
        subtitle.textColor          = theme.fifthTitle
    }
    
    var onTextSizeChanged: (() -> Void)?
    var onTextChanged: ((_ text: String) -> Void)?
    
    private let maxCellHeight: CGFloat = 100
    private let minCellHeight: CGFloat = 40

    func setup(_ name: String, placeholder: String) {
        textView.placeholder = placeholder as NSString
        textView.text = name
        textView.delegate?.textViewDidChange?(textView)
    }
}

extension GroupOverviewNameCell: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
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

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
