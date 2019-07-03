//
//  CalendarControlCollection.swift
//  Taskem
//
//  Created by Wilson on 1/26/19.
//  Copyright © 2019 Wilson. All rights reserved.
//

import Foundation

class CalendarControlCollection: UICollectionView {
    
    private var proxy: CalendarControlCollectionDelegateProxy = .init()
    
    public var onChangeItemsSelection: ((UICollectionView) -> Void)?
    
    override var delegate: UICollectionViewDelegate? {
        get {
            return proxy.delegate
        }
        set {
            proxy = .init()
            proxy.delegate = newValue
            super.delegate = proxy
        }
    }

    override func selectItem(at indexPath: IndexPath?, animated: Bool, scrollPosition: UICollectionView.ScrollPosition) {
        super.selectItem(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        onChangeItemsSelection?(self)
    }

    override func deselectItem(at indexPath: IndexPath, animated: Bool) {
        super.deselectItem(at: indexPath, animated: animated)
        onChangeItemsSelection?(self)
    }
}

fileprivate class CalendarControlCollectionDelegateProxy: NSObject {
    weak var delegate: UICollectionViewDelegate?
    
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

extension CalendarControlCollectionDelegateProxy: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        (collectionView as? CalendarControlCollection)?.onChangeItemsSelection?(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        delegate?.collectionView?(collectionView, didDeselectItemAt: indexPath)
        (collectionView as? CalendarControlCollection)?.onChangeItemsSelection?(collectionView)
    }
}
