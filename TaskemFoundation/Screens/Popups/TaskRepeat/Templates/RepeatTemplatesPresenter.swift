//
//  RepeatTemplatesPresenter.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public class RepeatTemplatesPresenter: RepeatTemplatesViewDelegate, DataInitiable {

    public weak var view: RepeatTemplatesView?
    public var router: RepeatTemplatesRouter
    public var interactor: RepeatTemplatesInteractor

    private let callback: TaskRepeatCallback
    
    public let initialData: InitialData
    
    public struct InitialData: CustomInitial, Equatable {
        public var `repeat`: RepeatPreferences = .init()
        
        public init() {}
        
        public init(repeat: RepeatPreferences) {
            self.repeat = `repeat`
        }
    }
    
    public init(
        view: RepeatTemplatesView,
        router: RepeatTemplatesRouter,
        interactor: RepeatTemplatesInteractor,
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
        self.view?.delegate = self
        self.interactor.delegate = self
    }

    private var viewModel: RepeatTemplatesListViewModel{
        get { return view?.viewModel ?? .init() }
        set { view?.viewModel = newValue }
    }
    
    private func produceViewModel() -> RepeatTemplatesListViewModel {
        return .init(sections: [
            .init(cells: [
                .init(title: "None", icon: .init(Images.Foundation.icCalendarNone), rule: .none)
                ]
            ),
            .init(cells: [
                .init(title: "Every day", icon: .init(Images.Foundation.icRepeatDaily), rule: .daily),
                .init(title: "By weekends", icon: .init(Images.Foundation.icRepeatWeekends), rule: .weekends),
                .init(title: "By weekdays", icon: .init(Images.Foundation.icRepeatWeekdays), rule: .weekdays),
                .init(title: "Every week", icon: .init(Images.Foundation.icRepeatWeekly), rule: .weekly),
                .init(title: "Every month", icon: .init(Images.Foundation.icRepeatMonthly), rule: .monthly),
                .init(title: "Every year", icon: .init(Images.Foundation.icRepeatYearly), rule: .yearly),
                ]
            ),
            .init(cells: [
                .init(title: "Custom", icon: .init(Images.Foundation.icRepeatCustom), rule: .custom)
                ]
            )
            ]
        )
    }

    public func onViewWillAppear() {
        view?.display(produceViewModel())
    }
    
    public func onTouchCell(at index: IndexPath) {
        let cell = viewModel[index]
        var repeatPref = initialData.repeat
        
        switch cell.rule {
        case .none:
            repeatPref.change(rule: .none)
            
        case .weekdays:
            repeatPref.rule = .weekly
            repeatPref.daysOfWeek = Calendar.current.allWeekdays

        case .weekends:
            repeatPref.rule = .weekly
            repeatPref.daysOfWeek = Calendar.current.allWeekends

        case .daily:
            repeatPref.change(rule: .daily)

        case .weekly:
            repeatPref.change(rule: .weekly)

        case .monthly:
            repeatPref.change(rule: .monthly)

        case .yearly:
            repeatPref.change(rule: .yearly)

        case .custom:
            router.presentManual(data: .init(repeat: repeatPref), callback: callback)
        }
        
        if cell.rule != .custom {
            callback(repeatPref)
            router.dismiss()
        }
    }

    public func onTouchBack() {
        callback(nil)
        router.dismiss()
    }
}


extension RepeatTemplatesPresenter: RepeatTemplatesInteractorOutput {

}
