//
//  TaskNameTableViewCell.swift
//  Taskem
//
//  Created by Wilson on 10.12.2017.
//  Copyright © 2017 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class TaskNameCell: UITableViewCell, ThemeObservable {

    @IBOutlet weak var subtitle: UILabel!
    
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var checkbox: Checkbox!
    @IBOutlet weak var checkboxWrapper: UIButton!

    @IBAction func touchCheckboxWrapper(_ sender: Any) {
        checkbox.isChecked = !checkbox.isChecked
        onTouchCheckbox?(checkbox.isChecked)
    }

    @IBAction func touchCheckbox(_ sender: Any) {
        onTouchCheckbox?(checkbox.isChecked)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        observeAppTheme()
        
        textViewHeight.constant = maxCellHeight
        textView.isScrollEnabled = true
        textView.delegate = self
        
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        textView.isUserInteractionEnabled = editing
        checkbox.isUserInteractionEnabled = editing
        checkboxWrapper.isUserInteractionEnabled = editing
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected && isEditing {
            textView.becomeFirstResponder()
        }
    }

    func applyTheme(_ theme: AppTheme) {
        setupCheckbox(theme)
        
        checkbox.backgroundColor         = .clear
        checkbox.checkboxBackgroundColor = .clear
        
        backgroundColor             = .clear
        contentView.backgroundColor = .clear
        
        textView.textColor          = theme.textView
        textView.placeholderColor   = theme.textViewPlaceholder
        subtitle.textColor          = theme.fifthTitle
    }
    
    private func setupCheckbox(_ theme: AppTheme) {
        checkbox.checkmarkStyle = .circle
        checkbox.borderStyle = .circle
        
        checkbox.layer.shadowRadius  = 4
        checkbox.layer.shadowOpacity = 0.3
    }
    
    private func refreshCheckbox(color: Color) {
        checkbox.layer.shadowColor = color.uicolor.cgColor
        checkbox.checkmarkColor = color.uicolor
        checkbox.uncheckedBorderColor = color.uicolor
        checkbox.checkedBorderColor = color.uicolor
        checkbox.setNeedsLayout()
    }
    
    var onTouchCheckbox: ((Bool) -> Void)?
    var onTextSizeChanged: (() -> Void)?
    var onTextEditing: ((Bool) -> Void)?
    var onTextDragging: ((Bool) -> Void)?
    var onTextChanged: ((_ cell: TaskNameCell, _ text: String) -> Void)?
    
    public var maxCellHeight: CGFloat = 250
    private let minCellHeight: CGFloat = 44

    func setup(_ viewModel: TaskOverviewViewModel.Name) {
        subtitle.text = viewModel.subtitle
        
        textView.placeholder = viewModel.placeholder as NSString
        textView.text = viewModel.title
        textView.delegate?.textViewDidChange?(textView)
        checkbox.isChecked = viewModel.checked
        
        refreshCheckbox(color: viewModel.color)
        
        subtitle.letterSpace = 1.5
    }
}

extension TaskNameCell: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        onTextDragging?(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        onTextDragging?(false)
    }
}

extension TaskNameCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        onTextEditing?(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onTextEditing?(false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(self, textView.text)
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
