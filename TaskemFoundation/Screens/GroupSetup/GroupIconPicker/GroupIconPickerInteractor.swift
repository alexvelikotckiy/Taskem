//
//  GroupIconPickerInteractor.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupIconPickerInteractorOutput: class {

}

public protocol GroupIconPickerInteractor: class {
    var delegate: GroupIconPickerInteractorOutput? { get set }
    
    var allIcons: [Icon] { get }
}

public class GroupIconPickerDefaultInteractor: GroupIconPickerInteractor {
    public weak var delegate: GroupIconPickerInteractorOutput?

    public init() {
    }

    public var allIcons: [Icon] {
        return Images.Lists.allImages.map(Icon.init)
    }
}
