//
//  DateProviderTestDoubles.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 12/13/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation
import TaskemFoundation

class DateProviderStub: DateProviderProtocol {
    var now: Date = DateProviderStub.nowStub
    var time: DayTime = DateProviderStub.timeStub

    static let nowStub: Date = Date(timeIntervalSince1970: 100_000)
    static let timeStub: DayTime = DayTime(hour: -1, minute: -1)
}
