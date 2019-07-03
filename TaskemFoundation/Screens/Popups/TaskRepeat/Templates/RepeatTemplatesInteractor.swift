//
//  RepeatTemplatesInteractor.swift
//  Taskem
//
//  Created by Wilson on 11/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

public protocol RepeatTemplatesInteractorOutput: class {

}

public protocol RepeatTemplatesInteractor {
    var delegate: RepeatTemplatesInteractorOutput? { get set }
}

public class RepeatTemplatesDefaultInteractor: RepeatTemplatesInteractor {

    public weak var delegate: RepeatTemplatesInteractorOutput?

    public init() {

    }
}
