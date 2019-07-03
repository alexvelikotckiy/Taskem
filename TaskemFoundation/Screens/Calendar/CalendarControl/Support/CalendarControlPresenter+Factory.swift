//
//  CalendarControlViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 8/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension CalendarControlPresenter: ViewModelFactory {
    public func produce<T>(from context: CalendarControlPresenter.Context) -> T? {
        switch true {
        case T.self == CalendarControlListViewModel.self:
            let value: CalendarControlListViewModel = produce(context)
            return value as? T
            
        case T.self == [CalendarControlSectionViewModel].self:
            let value: [CalendarControlSectionViewModel] = produce(context)
            return value as? T
            
        case T.self == [CalendarControlGroupModel].self:
            let value: [CalendarControlGroupModel] = produce(context)
            return value as? T
            
        case T.self == [CalendarControlIOSCalendarModel].self:
            let value: [CalendarControlIOSCalendarModel] = produce(context)
            return value as? T
            
        case T.self == [CalendarControlViewModel].self:
            let value: [CalendarControlViewModel] = produce(context)
            return value as? T
            
        default:
            return nil
        }
    }
    
    public struct Context: Equatable {
        public var lists: [Group] = []
        public var calendars: [EventKitCalendar] = []
    }
}

private extension CalendarControlPresenter {
    func produce(_ context: Context) -> CalendarControlListViewModel {
        return .init(sections: produce(context))
    }
    
    func produce(_ context: Context) -> [CalendarControlSectionViewModel] {
        return [
            .init(
                title: "Taskem Lists".uppercased(),
                cells: produceLists(context)
            ),
            .init(
                title: "Apple Calendars".uppercased(),
                cells: produceCalendars(context)
            ),
        ]
    }
    
    func produce(_ context: Context) -> [CalendarControlGroupModel] {
        return context.lists.map { .init(group: $0, isSelected: resolveIsSelected($0)) }
    }
    
    func produce(_ context: Context) -> [CalendarControlIOSCalendarModel] {
        return context.calendars.map { .init(calendar: $0, isSelected: resolveIsSelected($0)) }
    }
    
    func produce(_ context: Context) -> [CalendarControlViewModel] {
        return [
            produceLists(context),
            produceCalendars(context)
        ].flatMap { $0 }
    }

    private func produceLists(_ context: Context) -> [CalendarControlViewModel] {
        let lists: [CalendarControlGroupModel] = produce(context)
        return [lists.map { .group($0) }].flatMap { $0 }
    }
    
    private func produceCalendars(_ context: Context) -> [CalendarControlViewModel] {
        let calendars: [CalendarControlIOSCalendarModel] = produce(context)
        return [calendars.map { .calendar($0) }].flatMap { $0 }
    }

    private func resolveIsSelected(_ calendar: EventKitCalendar) -> Bool {
        return !self.config.unselectedAppleCalendars.contains(calendar.id)
    }
    
    private func resolveIsSelected(_ group: Group) -> Bool {
        return !self.config.unselectedTaskemGroups.contains(group.id)
    }
}
