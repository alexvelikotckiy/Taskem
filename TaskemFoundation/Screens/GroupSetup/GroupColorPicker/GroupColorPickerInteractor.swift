//
//  GroupColorPickerInteractor.swift
//  Taskem
//
//  Created by Wilson on 21/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol GroupColorPickerInteractorOutput: class {

}

public protocol GroupColorPickerInteractor: class {
    var delegate: GroupColorPickerInteractorOutput? { get set }
}

public class GroupColorPickerDefaultInteractor: GroupColorPickerInteractor {
    public weak var delegate: GroupColorPickerInteractorOutput?

    public init() {
    }
}
