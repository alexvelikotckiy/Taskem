//
//  CGAffineTransform+Helpers.swift
//  Taskem
//
//  Created by Wilson on 02.01.2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public extension CGAffineTransform {

    init(fromRect: CGRect, toRect: CGRect) {
        let scales = CGSize(width: toRect.size.width/fromRect.size.width, height: toRect.size.height/fromRect.size.height)
        let offset = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
        self = CGAffineTransform(a: scales.width, b: 0, c: 0, d: scales.height, tx: offset.x, ty: offset.y)
    }

}
