//
//  DatePickerManualViewController.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation
import FSCalendar

class DatePickerManualViewController: UIViewController, DatePickerManualView, ModalPresentable, ThemeObservable {

   // MARK: IBOutlet
    @IBOutlet weak var time: UIDatePicker!
    @IBOutlet weak var calendar: TaskemCalendar!
    
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var pickersHeight: NSLayoutConstraint!

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var allDayTitle: UILabel!
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    // MARK: IBAction
    @IBAction func touchScreenPicker(_ sender: UIButton) {
        switch sender {
        case dateButton:
            delegate?.onTouchChangePicker(.calendar)
            
        case timeButton:
            delegate?.onTouchChangePicker(.time)
            
        default:
            break
        }
    }
    
    @IBAction func touchSave(_ sender: UIButton) {
        delegate?.onTouchSave()
    }

    @IBAction func switchIsTime(_ sender: UISwitch) {
        delegate?.onSwitchTime(isAllDay: sender.isOn)
    }

    @IBAction func onChangeTime(_ sender: UIDatePicker) {
        delegate?.onSelect(date: sender.date, on: .time)
    }

    // MARK: let & var
    var presenter: DatePickerManualPresenter!
    var viewModel: DatePickerManualViewModel = .init()
    weak var delegate: DatePickerManualViewDelegate?

    private let tagSeparator = 100 // All separator lines
    
    // MARK: class func
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onViewWillAppear()
    }

    // MARK: func
    public func applyTheme(_ theme: AppTheme) {
        view.backgroundColor = theme.background
        allDayTitle.textColor = theme.fourthTitle
        
        time.setValue(theme.secondTitle, forKey: "textColor")
        
        resolveButtonsColor(theme)
        
        view.viewsWithTag(tag: tagSeparator).forEach {
            $0.backgroundColor = theme.separatorThird
        }
    }
    
    private func setupUI() {
        observeAppTheme()
        
        dateButton.setImage(Images.Foundation.icCalendar.image, for: .normal)
        timeButton.setImage(Images.Foundation.icClock.image, for: .normal)
    }
    
    internal func willDismiss() {
        delegate?.onViewWillDismiss()
    }
    
    private func resolveButtonsColor(_ theme: AppTheme) {
        dateButton.tintColor = resolveDateColor(theme)
        timeButton.tintColor = resolveTimeColor(theme)
        dateButton.setTitleColor(resolveDateColor(theme), for: .normal)
        timeButton.setTitleColor(resolveTimeColor(theme), for: .normal)
    }
    
    private func resolveDateColor(_ theme: AppTheme) -> UIColor {
        return viewModel.isOverdueDate ? theme.redTitle : theme.fourthTitle
    }
    
    private func resolveTimeColor(_ theme: AppTheme) -> UIColor {
        if viewModel.isOverdueTime {
            return theme.redTitle
        } else {
            return viewModel.isAllDay ? theme.activeBlueButton : theme.fourthTitle
        }
    }

    private func showCalendar(animated: Bool) {
        calendar.isHidden = false
        time.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: animated ? 0.2 : 0.0, curve: .easeInOut) {
            self.calendar.alpha = 1
        }
        animator.addCompletion { position in
            if position == .end {
                self.time.isHidden = true
            }
        }
        animator.startAnimation()
    }
    
    private func showTimePicker(animated: Bool) {
        time.isHidden = false
        calendar.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: animated ? 0.2 : 0.0, curve: .easeInOut) {
            self.time.alpha = 1
        }
        animator.addCompletion { position in
            if position == .end {
                self.calendar.isHidden = true
            }
        }
        animator.startAnimation()
    }

    private func adjustHeight() {
        let height = calendarHeight.constant + pickersHeight.constant
        adjustTo(height: height, animated: true)
    }

    private func reloadContent(_ viewModel: DatePickerManualViewModel) {
        dateButton.setTitle(viewModel.dateTitle, for: .normal)
        timeButton.setTitle(viewModel.timeTitle, for: .normal)
        
        resolveButtonsColor(AppTheme.current)
        
        calendar.select(viewModel.date, scrollToDate: false)
        time.setDate(viewModel.date ?? Date.now, animated: true)
        allDaySwitch.setOn(viewModel.isAllDay, animated: true)
        
        switch viewModel.mode {
        case .calendar:
            showCalendar(animated: true)

        case .time:
            showTimePicker(animated: true)
        }
    }

    func display(_ viewModel: DatePickerManualViewModel) {
        self.viewModel = viewModel
        reloadContent(viewModel)
        adjustHeight()
    }
    
    func scrollToDate(_ date: Date) {
        calendar.select(date, scrollToDate: true)
    }
    
    func scrollToTime(_ date: Date) {
        time.setDate(date, animated: true)
    }
}

extension DatePickerManualViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.onSelect(date: date, on: .calendar)
    }
}
