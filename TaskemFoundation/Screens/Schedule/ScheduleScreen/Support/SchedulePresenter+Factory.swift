//
//  ScheduleViewModelFactory.swift
//  TaskemFoundation
//
//  Created by Wilson on 7/18/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol ScheduleCellConvertible {
    var convertToSchedule: ScheduleCellViewModel { get }
}

public typealias ScheduleCellsConvertible = [ScheduleCellConvertible]

extension ScheduleCellViewModel: ScheduleCellConvertible {
    public var convertToSchedule: ScheduleCellViewModel {
        return self
    }
}

extension TaskModel: ScheduleCellConvertible {
    public var convertToSchedule: ScheduleCellViewModel {
        return .task(self)
    }
}

extension CalendarTimeCell: ScheduleCellConvertible {
    public var convertToSchedule: ScheduleCellViewModel {
        return .time(self)
    }
}

extension SchedulePresenter: ViewModelFactory {
    public func produce<T>(from context: SchedulePresenter.Context) -> T? {
        switch context {
        case .list(let data, let style, let lists, let shouldExpandAllSections):
            return list(data, style, lists, shouldExpandAllSections) as? T
        case .sections(let data, let style, let shouldExpandAllSections):
            return sections(data, style, shouldExpandAllSections) as? T
        case .cells(let data):
            return cells(data) as? T
        case .navbar(let lists):
            return navbar(lists) as? T
        case .time:
            return time() as? T
        }
    }
    
    public enum Context {
        case list(ScheduleCellsConvertible, ScheduleTableType, [Group], Bool)
        case sections(ScheduleCellsConvertible, ScheduleTableType, Bool)
        case cells(ScheduleCellsConvertible)
        case navbar([Group])
        case time
    }
}

private extension SchedulePresenter {
    func list(_ data: ScheduleCellsConvertible, _ style: ScheduleTableType, _ lists: [Group], _ shouldExpandAllSections: Bool) -> ScheduleListViewModel {
        return ScheduleListViewModel(
            sections: sections(data, style, shouldExpandAllSections),
            title: "Schedule",
            navbarData: navbar(lists),
            type: style
        )
    }
    
    func sections(_ data: ScheduleCellsConvertible, _ style: ScheduleTableType, _ shouldExpandAllSections: Bool) -> [ScheduleSectionViewModel] {
        let cells = self.cells(data).uniqueElements
        
        let sections: [ScheduleSectionViewModel] = {
            switch style {
            case .schedule:
                return ScheduleSection.allCases.reduce(into: []) { result, status in
                    let content = cells
                        .removeTimeIfNeed()
                        .insertTimeIfNeed(at: status, time: time())
                        .filter(filterPredicate(sectionType: .schedule(status)))
                        .sorted(by: sortPredicate)
                    
                    guard !content.isEmpty, !content.containOnlyTimeCell else { return }
                    result.append(ScheduleSectionViewModel(content, status: status))
                }
            case .project:
                return interactor.sourceGroups.info.order.reduce(into: []) { result, id in
                    let content = cells
                        .removeTimeIfNeed()
                        .filter(filterPredicate(sectionType: .project(id)))
                        .sorted(by: sortPredicate)
                    
                    guard !content.isEmpty, let title = content.firstListName else { return }
                    result.append(ScheduleSectionViewModel(content, idGroup: id, title: title))
                }
            case .flat:
                return ScheduleFlatSection.allCases.reduce(into: []) { result, status in
                    let content = cells
                        .removeTimeIfNeed()
                        .insertTimeIfNeed(at: status, time: time())
                        .filter(filterPredicate(sectionType: .flat(status)))
                        .sorted(by: sortPredicate)
                    
                    guard !content.isEmpty, !content.containOnlyTimeCell else { return }
                    result.append(ScheduleSectionViewModel(content, status: status))
                }
            }
        }()
        sections.forEach {
            $0.isExpanded = isExpanded(section: $0, shouldExpandByDefault: shouldExpandAllSections)
        }
        return sections
    }
    
    func cells(_ data: ScheduleCellsConvertible) -> [ScheduleCellViewModel] {
        return data.map { $0.convertToSchedule }.sorted(by: sortPredicate)
    }
    
    func navbar(_ lists: [Group]) -> [ScheduleNavbarCell] {
        return lists.filter { config.selectedProjects.contains($0.id) }.map { ScheduleNavbarCell(group: $0) }
    }
    
    func time() -> CalendarTimeCell {
        let now = Date.now
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            return formatter
        }()
        return CalendarTimeCell(time: dateFormatter.string(from: now), date: now)
    }
}

private extension SchedulePresenter {
    func isExpanded(section: ScheduleSectionViewModel, shouldExpandByDefault: Bool) -> Bool {
        switch shouldExpandByDefault {
        case true:
            return true
            
        case false:
            switch section.type {
            case .schedule:
                if case .schedule(let status) = section.type {
                    return !config.scheduleUnexpanded.contains(status)
                }
            case .project:
                if case .project(let id) = section.type {
                    return !config.projectsUnexpanded.contains(id)
                }
            case .flat:
                if case .flat(let flatStatus) = section.type {
                    return !config.flatUnexpanded.contains(flatStatus)
                }
            }
        }
        return true
    }
}

fileprivate extension Array where Element == ScheduleCellViewModel {
    var containOnlyTimeCell: Bool {
        return self.count == 1 && self.first?.id == "Time"
    }
    
    var firstListName: String? {
        return self.compactMap { $0.unwrapTask() }.first?.groupName
    }
    
    @discardableResult
    func removeTimeIfNeed() -> [Element] {
        return self.filter { !$0.isTime }
    }
    
    @discardableResult
    func insertTimeIfNeed(at status: ScheduleSection, time: CalendarTimeCell) -> [Element] {
        var mutable = self
        if status == .today {
            mutable.append(time.convertToSchedule)
        }
        return mutable
    }
    
    @discardableResult
    func insertTimeIfNeed(at status: ScheduleFlatSection, time: CalendarTimeCell) -> [Element] {
        var mutable = self
        if status == .uncomplete {
            mutable.append(time.convertToSchedule)
        }
        return mutable
    }
}

fileprivate extension ScheduleSectionViewModel {
    
    convenience init(
        _ cells: [ScheduleCellViewModel],
        status: ScheduleFlatSection
        ) {
        self.init(
            cells,
            status.description,
            .flat(status),
            .action(for: status)
        )
    }
    
    convenience init(
        _ cells: [ScheduleCellViewModel],
        idGroup: EntityId,
        title: String
        ) {
        self.init(
            cells,
            title, .project(idGroup),
            .action(for: idGroup)
        )
    }
    
    convenience init(
        _ cells: [ScheduleCellViewModel],
        status: ScheduleSection
        ) {
        self.init(
            cells,
            status.description,
            .schedule(status),
            .action(for: status)
        )
    }
    
    convenience init(
        _ cells: [ScheduleCellViewModel],
        _ title: String,
        _ type: ScheduleSectionType,
        _ actionType: ScheduleSectionAction
        ) {
        self.init(
            cells: cells,
            title: title,
            type: type,
            actionType: actionType
        )
    }
}
