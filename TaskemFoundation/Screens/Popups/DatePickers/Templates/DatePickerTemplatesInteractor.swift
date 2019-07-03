//
//  DatePickerTemplatesInteractor.swift
//  Taskem
//
//  Created by Wilson on 14/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol DatePickerTemplatesInteractorOutput: class {

}

public protocol DatePickerTemplatesInteractor {
    var delegate: DatePickerTemplatesInteractorOutput? { get set }
}

public class DatePickerTemplatesDefaultInteractor: DatePickerTemplatesInteractor {
    weak public var delegate: DatePickerTemplatesInteractorOutput?

    public init() {

    }

}
