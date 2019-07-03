//
//  ScheduleDataObserver.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/24/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

private var tickDate: Date = Date.now

extension SchedulePresenter {
    
    public func startTimer() {
        timer.start()
        timer.setOnTick(didChangeTime)
        tickDate = Date.now
    }
    
    public func stopTimer() {
        timer.stop()
    }
    
    public func showAllDoneIfNeed() {
        switch state {
        case .searching:
            return
        default:
            if viewModel.sectionsCount() == 0 {
                view?.displayNotFound(false)
                view?.displayAllDone(true)
            } else {
                view?.displayAllDone(false)
            }
        }
    }

    public func showNotFoundIfNeed() {
        switch state {
        case .searching:
            if viewModel.sectionsCount() == 0 {
                view?.displayAllDone(false)
                view?.displayNotFound(true)
            } else {
                view?.displayNotFound(false)
            }
        default:
            return
        }
    }
    
    private func didChangeTime() {
        let now = self.now

        if isNewMinute {
            if isNewDay {
                view?.display(viewModel: viewModel)
            } else {
                if isContainTimeCell {
                    updateTimeIfNeed()
                } else if isContainSectionWithTime {
                    insertTimeIfNeed()
                }
            }

            tickDate = now
        }
    }

    private func insertTimeIfNeed() {
        guard let sectionIndex = indexForSectionWithTime() else { return }

        if !isContainTimeCell {
            let time: CalendarTimeCell = produce(from: .time)!

            if viewModel[sectionIndex].isExpanded {
                coordinator.insert([time], silent: false)
            } else {
                coordinator.insert([time], silent: true)
            }
        }
    }

    private func updateTimeIfNeed() {
        guard let index = indexForTimeCell() else { return }

        let time: CalendarTimeCell = produce(from: .time)!

        if viewModel[index.section].isExpanded {
            coordinator.update([time], silent: false)
        } else {
            coordinator.update([time], silent: true)
        }
    }

    private func removeTimeIfNeed() {
        guard let index = indexForTimeCell() else { return }

        if isTimeOnlyCellInSection(at: index.section) {
            if viewModel[index.section].isExpanded {
                coordinator.remove([viewModel[index]], silent: false)
            } else {
                coordinator.remove([viewModel[index]], silent: true)
            }
        }
    }
    
    private var viewModel: ScheduleListViewModel {
        return view?.viewModel ?? .init()
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
        return viewModel["Time"] != nil
    }

    private var isContainSectionWithTime: Bool {
        return indexForSectionWithTime() != nil
    }

    private func indexForSectionWithTime() -> Int? {
        return viewModel.indexOfSection(for: now.startOfDay)
    }

    private func indexForTimeCell() -> IndexPath? {
        return viewModel.index(for: "Time")
    }

    private func isTimeOnlyCellInSection(at index: Int) -> Bool {
        return viewModel[index].cells.count == 1 && viewModel[index].cells.first?.id == "Time"
    }

    private func reloadSections(at indexes: [IndexPath]) {
        let indexes = indexes.filter { !$0.isEmpty }.map { $0.section }.unique().sorted()
        indexes.forEach { view?.displayHeader(model: viewModel[$0], at: $0) }
    }
}

extension SchedulePresenter: TableCoordinatorObserver {
    public func didBeginUpdate() {

    }

    public func didEndUpdate() {

    }

    public func didInsertRow(at index: IndexPath) {
        insertTimeIfNeed()
        reloadSections(at: [index])
        showAllDoneIfNeed()
    }

    public func didUpdateRow(at index: IndexPath) {

    }

    public func didDeleteRow(at index: IndexPath) {
        removeTimeIfNeed()
        reloadSections(at: [index])
        showAllDoneIfNeed()
    }

    public func didInsertSections(at indexes: IndexSet) {
        insertTimeIfNeed()
        let indexes = Array(indexes).map { IndexPath(row: 0, section: $0) }
        reloadSections(at: indexes)
        showAllDoneIfNeed()
    }

    public func didDeleteSections(at indexes: IndexSet) {
        showAllDoneIfNeed()
    }

    public func didMoveRow(from: IndexPath, to index: IndexPath) {
        removeTimeIfNeed()
        reloadSections(at: [from, index])
        showAllDoneIfNeed()
    }
}
