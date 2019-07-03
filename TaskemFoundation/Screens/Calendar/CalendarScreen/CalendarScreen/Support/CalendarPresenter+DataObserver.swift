//
//  CalendarPresenter+DataObserver.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/17/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

private var tickDate: Date = Date.now

extension CalendarPresenter {
    public func startTimer() {
        timer.start()
        timer.setOnTick(didChangeTime)
    }
    
    public func stopTimer() {
        timer.stop()
    }
    
    private func didChangeTime() {
        let now = self.now
        
        if isNewMinute {
            if isNewDay {
                view?.display(viewModel: viewModel)
            } else {
                if isContainTimeCell {
                    updateTimeIfNeed()
                } else if isContainSectionWithTime && !isContainFreeday {
                    insertTimeIfNeed()
                }
            }
            
            tickDate = now
        }
    }
    
    private func insertTimeIfNeed() {
        guard !isContainTimeCell && !isContainFreeday else { return }
        
        let time: CalendarTimeCell = produce(from: .time)!
        coordinator.insert([time], silent: false)
    }
    
    private func updateTimeIfNeed() {
        guard isContainTimeCell else { return }
        
        let time: CalendarTimeCell = produce(from: .time)!
        coordinator.update([time], silent: false)
    }
    
    private func removeTimeIfNeed() {
        guard let index = indexForTimeCell() else { return }
        
        if (viewModel.style == .bydate && isContainOnlyTimeCell) || isContainFreeday || isEmptyList {
            coordinator.remove([viewModel[index]], silent: false)
        }
    }
    
    private func insertFreedayIfNeed() {
        if isEmptyList || isContainOnlyTimeCell {
            
            let freeday: CalendarFreeDayCell = produce(from: .freeday(date: viewModel.currentDate))!
            coordinator.insert([freeday], silent: false)
        }
    }
    
    private func removeFreedayIfNeed() {
        guard let index = indexForFreedayCell() else { return }
        
        if !isContainOnlyFreedayCell {
            coordinator.remove([viewModel[index]], silent: false)
        }
    }
    
    private var viewModel: CalendarListViewModel {
        return view?.viewModel ?? .init()
    }
    
    private var isEmptyList: Bool {
        return viewModel.allCells.count == 0
    }
    
    private var now: Date {
        return dateProvider.now
    }
    
    private var isNewMinute: Bool {
        return tickDate.minutes != now.minutes || tickDate.hour != now.hour
    }
    
    private var isNewDay: Bool {
        return tickDate.day != now.day
    }
    
    private var isContainTimeCell: Bool {
        return viewModel[CalendarStaticCell.time] != nil
    }
    
    private var isContainFreeday: Bool {
        return viewModel[CalendarStaticCell.freeday] != nil
    }
    
    private func indexForTimeCell() -> IndexPath? {
        return viewModel.index(for: CalendarStaticCell.time)
    }
    
    private func indexForFreedayCell() -> IndexPath? {
        return viewModel.index(for: CalendarStaticCell.freeday)
    }
    
    private var isContainSectionWithTime: Bool {
        return indexForSectionWithTime() != nil
    }
    
    private func indexForSectionWithTime() -> Int? {
        return viewModel.sections.index(for: now.startOfDay)
    }
    
    private var isContainOnlyTimeCell: Bool {
        if viewModel.allCells.count == 1 {
            return viewModel.allCells[0].id == CalendarStaticCell.time
        }
        return false
    }
    
    private var isContainOnlyFreedayCell: Bool {
        if viewModel.allCells.count == 1 {
            return viewModel.allCells[0].id == CalendarStaticCell.freeday
        }
        return false
    }
}

extension CalendarPresenter: TableCoordinatorObserver {
    public func didBeginUpdate() {
        
    }
    
    public func didEndUpdate() {
        
    }
    
    public func didInsertSections(at indexes: IndexSet) {
        insertTimeIfNeed()
        insertFreedayIfNeed()
        view?.canScroll(viewModel.canScrollTable)
    }
    
    public func didDeleteSections(at indexes: IndexSet) {
        
    }
    
    public func didInsertRow(at index: IndexPath) {
        removeFreedayIfNeed()
        insertTimeIfNeed()
        view?.canScroll(viewModel.canScrollTable)
    }
    
    public func didUpdateRow(at index: IndexPath) {
        
    }
    
    public func didDeleteRow(at index: IndexPath) {
        removeTimeIfNeed()
        insertFreedayIfNeed()
        view?.canScroll(viewModel.canScrollTable)
    }
    
    public func didMoveRow(from: IndexPath, to index: IndexPath) {
        removeTimeIfNeed()
    }
}
