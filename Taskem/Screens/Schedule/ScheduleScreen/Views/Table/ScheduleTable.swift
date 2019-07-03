//
//  ScheduleTable.swift
//  Taskem
//
//  Created by Wilson on 1/12/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

class ScheduleTable: UITableView {
    
    private var proxy: ScheduleTableDelegateProxy = .init()
    
    public var onChangeRowsSelection: ((UITableView) -> Void)?
    
    override var delegate: UITableViewDelegate? {
        get {
            return proxy.delegate
        }
        set {
            proxy = .init()
            proxy.delegate = newValue
            super.delegate = proxy
        }
    }
    
    override func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) {
        super.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        onChangeRowsSelection?(self)
    }

    override func deselectRow(at indexPath: IndexPath, animated: Bool) {
        super.deselectRow(at: indexPath, animated: animated)
        onChangeRowsSelection?(self)
    }
    
    public func defaultSafeAreaInsets(in controller: UIViewController) -> UIEdgeInsets  {
        return .init(top: 0, left: 0, bottom: controller.tabBarController?.tabBar.frame.height ?? 0, right: 0)
    }
}

fileprivate class ScheduleTableDelegateProxy: NSObject {
    weak var delegate: UITableViewDelegate?
    
    @objc override func conforms(to aProtocol: Protocol) -> Bool {
        return super.conforms(to: aProtocol)
            || (delegate?.conforms(to: aProtocol) ?? false)
    }

    @objc override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector)
            || (delegate?.responds(to: aSelector) ?? false)
    }

    @objc override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if delegate?.responds(to: aSelector) ?? false {
            return delegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}

extension ScheduleTableDelegateProxy: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        (tableView as? ScheduleTable)?.onChangeRowsSelection?(tableView)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
        (tableView as? ScheduleTable)?.onChangeRowsSelection?(tableView)
    }
}
