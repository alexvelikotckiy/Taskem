//
//  CollectionView+Getters.swift
//  Taskem
//
//  Created by Wilson on 15.03.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

extension UICollectionView {

    func registerHeader<T: UICollectionReusableView>(view: T.Type, bundle: Bundle? = nil) {
        self.register(UINib(nibName: "\(view)", bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(view)")
    }
    
    func register<T: UICollectionViewCell>(cell: T.Type, bundle: Bundle? = nil) {
        self.register(UINib(nibName: "\(cell)", bundle: bundle), forCellWithReuseIdentifier: "\(cell)")
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(T.self, indexPath)
    }

    func dequeueReusableView<T: UICollectionReusableView>(_ type: T.Type, kind: String, for index: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(type)", for: index) as! T
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
