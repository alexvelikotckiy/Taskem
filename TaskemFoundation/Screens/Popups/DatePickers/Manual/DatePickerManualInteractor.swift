//
//  DatePickerManualInteractor.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DatePickerManualInteractorOutput: class {
    
}

public protocol DatePickerManualInteractor {
    var delegate: DatePickerManualInteractorOutput? { get set }
}

public class DatePickerManualDefaultInteractor: DatePickerManualInteractor {

    public weak var delegate: DatePickerManualInteractorOutput?

    public init() {

    }
}
