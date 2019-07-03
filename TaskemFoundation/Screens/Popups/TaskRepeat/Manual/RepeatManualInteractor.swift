//
//  RepeatManualInteractor.swift
//  Taskem
//
//  Created by Wilson on 05/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol RepeatManualInteractorOutput: class {

}

public protocol RepeatManualInteractor: class {
    var delegate: RepeatManualInteractorOutput? { get set }
}

public class RepeatManualDefaultInteractor: RepeatManualInteractor {

    public weak var delegate: RepeatManualInteractorOutput?

    public init() {

    }
}
