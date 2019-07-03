//
//  ColorTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ColorTestCase: XCTestCase {
    func testShouldParse() {
        expect(Color(hex: "0xFFFFFF")) == Color.white
        expect(Color(hex: "FFFFFF")) == Color.white
        expect(Color(hex: "#FFFFFF")) == Color.white
        expect(Color(hex: "0xffffff")) == Color.white
        expect(Color(hex: "ffffff")) == Color.white
        expect(Color(hex: "#ffffff")) == Color.white
        expect(Color(hex: "")) == Color.black
        expect(Color(hex: "0xfffffffffffff")) == Color.black
    }
}
