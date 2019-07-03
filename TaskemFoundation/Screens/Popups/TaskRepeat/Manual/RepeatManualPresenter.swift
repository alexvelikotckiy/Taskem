//
//  RepeatManualPresenter.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class RepeatManualPresenter: RepeatManualViewDelegate, DataInitiable {

    public unowned var view: RepeatManualView
    public var router: RepeatManualRouter
    public var interactor: RepeatManualInteractor

    private let callback: TaskRepeatCallback

    public var initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var `repeat`: RepeatPreferences = .init()
        
        public init() {
            self = validateInitialData(self)
        }
        
        public init(repeat: RepeatPreferences) {
            self.repeat = `repeat`
            self = validateInitialData(self)
        }
        
        private func validateInitialData(_ data: InitialData) -> InitialData {
            var mutable = data
            if data.repeat.rule == .none {
                mutable.repeat = .init(rule: .daily, daysOfWeek: data.repeat.daysOfWeek, endDate: data.repeat.endDate)
            }
            return mutable
        }
    }
    
    public init(
        view: RepeatManualView,
        router: RepeatManualRouter,
        interactor: RepeatManualInteractor,
        data: InitialData,
        callback: @escaping TaskRepeatCallback
        ) {
        self.view = view
        self.router = router
        self.interactor = interactor
        //        
        self.initialData = data
        self.callback = callback
        //
        self.view.delegate = self
        self.interactor.delegate = self
    }
    
    private var viewModel: RepeatManualListViewModel {
        return view.viewModel
    }
    
    private func produceViewModel(_ data: InitialData) -> RepeatManualListViewModel {
        let cells = [
            produceRepeatSelector(data.repeat),
            produceDayOfWeeks(data.repeat),
            produceEndDate(data.repeat)
        ].compactMap { $0 }
    
        return .init(
            repeat: data.repeat,
            sections: cells.map { .init(cells: [$0]) }
        )
    }

    private func reloadDayOfWeeksIfNeed() {
        let dayOfWeekIndex = viewModel.index { $0.isDayOfWeek }
        
        if viewModel.repeat.rule == .weekly {
            if dayOfWeekIndex == nil {
                let index = IndexPath(row: 0, section: 1)
                viewModel.insertCell(produceDayOfWeeks(viewModel.repeat)!, at: index)
                view.insertCell(at: index)
            }
        } else {
            if let index = dayOfWeekIndex {
                viewModel.remove(at: index)
                view.removeCell(at: index)
            }
        }
    }

    public func onViewWillAppear() {
        view.display(produceViewModel(initialData))
    }
    
    public func onTouchRepeatType(cellIndex: IndexPath, at index: Int) {
        guard let rule = RepeatModelData.Model(index: index) else { return }
        
        var repetiton = viewModel.repeat
        switch rule {
        case .daily:
            if repetiton.rule == .daily { return }
            repetiton.change(rule: .daily)
            
        case .weekly:
            if repetiton.rule == .weekly { return }
            repetiton.change(rule: .weekly)
            
        case .monthly:
            if repetiton.rule == .monthly { return }
            repetiton.change(rule: .monthly)
            
        case .yearly:
            if repetiton.rule == .yearly { return }
            repetiton.change(rule: .yearly)
        }
        viewModel.repeat = repetiton
        
        viewModel[cellIndex] = produceRepeatSelector(repetiton)
        
        reloadDayOfWeeksIfNeed()
    }
    
    public func onTouchDaysOfWeek(cellIndex: IndexPath, at index: Int) {
        viewModel.repeat.daysOfWeek.formSymmetricDifference([convertWeekdayToFoundation(day: index)])
        
        viewModel[cellIndex] = produceDayOfWeeks(viewModel.repeat)!
    }

    public func onChangeEndDate(cellIndex: IndexPath, date: Date?) {
        viewModel.repeat.endDate = date
        
        switch viewModel[cellIndex] {
        case .endDate(let cell):
            viewModel[cellIndex] = produceEndDate(viewModel.repeat, style: cell.style)
            view.reloadCell(at: cellIndex, with: .none)
            
        default:
            break
        }
    }

    public func onTouchCell(at index: IndexPath) {
        switch viewModel[index] {
        case .endDate(let cell):
            viewModel[index] = produceEndDate(viewModel.repeat, style: cell.style.toogle())
            view.reloadCell(at: index, with: .automatic)
            
        default:
            break
        }
    }
    
    public func onTouchSave() {
        callback(viewModel.repeat)
        router.dismiss()
    }
}

private extension RepeatManualPresenter {
    
    private var weekdaySymbols: [String] {
        switch UserPreferences.current.firstWeekday {
        case .monday:
            var symbols = Calendar.current.veryShortWeekdaySymbols
            symbols.append(symbols.removeFirst())
            return symbols
            
        case .sunday:
            return Calendar.current.veryShortWeekdaySymbols
        }
    }
    
    private func convertWeekdayToUI(day: Int) -> Int {
        switch UserPreferences.current.firstWeekday {
        case .monday:
            if day - 1 == 0 {
                return Calendar.current.allDaysOfWeek.count
            }
            return day - 1

        case .sunday:
            return day
        }
    }
    
    private func convertWeekdayToFoundation(day: Int) -> Int {
        switch UserPreferences.current.firstWeekday {
        case .monday:
            if day + 1 > Calendar.current.allDaysOfWeek.count {
                return 1
            }
            return day + 1
            
        case .sunday:
            return day
        }
    }
    
    private func produceRepeatSelector(_ repetition: RepeatPreferences) -> RepeatManualListViewModel.Cell {
        return .repetition(
            .init(
                selected: .init(rule: repetition.rule)
            )
        )
    }
    
    private func produceDayOfWeeks(_ repetition: RepeatPreferences) -> RepeatManualListViewModel.Cell? {
        guard repetition.rule == .weekly else { return nil }
        return .daysOfWeek(
            .init(
                days: weekdaySymbols,
                selected: repetition.daysOfWeek.array.map(convertWeekdayToUI)
            )
        )
    }
    
    private func produceEndDate(_ repetition: RepeatPreferences,
                                style: RepeatEndDateData.Presentation = .extended) -> RepeatManualListViewModel.Cell {
        return .endDate(
            .init(
                dateTitle: resolveEndDateTitle(repetition),
                dateSubtitle: resolveEndDateSubtitle(repetition),
                date: repetition.endDate,
                displayType: style
            )
        )
    }
    
    private func resolveEndDateTitle(_ repetition: RepeatPreferences) -> String {
        guard let endDate = repetition.endDate else {
            return "Never"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: endDate)
    }
    
    private func resolveEndDateSubtitle(_ repetition: RepeatPreferences) -> String {
        guard let endDate = repetition.endDate else { return "" }
        
        let dateDifference = Calendar.current.taskem_dateDifference(from: Date.now.startOfDay, to: endDate.startOfDay)

        let dayCount = dateDifference.day!
        let monthCount = dateDifference.month!
        let yearCount = dateDifference.year!

        var subtitle = ""
        
        if dayCount > 0 || monthCount > 0 || yearCount > 0 {
            subtitle = "in"
            if yearCount > 0 {
                subtitle += " \(yearCount)"
                subtitle += yearCount == 1 ? " year" : " years"
            }

            if monthCount > 0 {
                if yearCount != 0 {
                    subtitle += ","
                }
                subtitle += " \(monthCount)"
                subtitle += monthCount == 1 ? " month" : " months"
            }

            if yearCount == 0, dayCount > 0 {
                if monthCount != 0 {
                    subtitle += ","
                }
                subtitle += " \(dayCount)"
                subtitle += dayCount == 1 ? " day" : " days"
            }
        }
        return subtitle
    }
}

extension RepeatManualPresenter: RepeatManualInteractorOutput {

}
