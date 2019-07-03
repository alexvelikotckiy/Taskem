//
//  ObserverCollectionTestCase.swift
//  TaskemFoundationTests
//
//  Created by Wilson on 9/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import XCTest
import TaskemFoundation
import Nimble

class ObserverCollectionTestCase: XCTestCase {

    private class Observer { }
    
    private var collection: ObserverCollection<Observer>!
    private var observerOne = Observer()
    private var observerTwo = Observer()
    
    override func setUp() {
        super.setUp()
        
        collection = .init([observerOne, observerTwo])
    }

    func testShouldAddObserver() {
        let observer = Observer()
        
        collection.append(observer)
        
        expect(self.collection.count) == 3
        expect(self.collection.last) === observer
    }
    
    func testShouldRemoveObserver() {
        collection.remove(observerOne)
        
        expect(self.collection.count) == 1
        expect(self.collection.first) === observerTwo
    }
    
    func testShouldMakeInterator() {
        let iterator = collection.makeIterator()
        
        for pair in iterator.enumerated() {
            if pair.offset == 0 {
                expect(pair.element) === observerOne
            } else {
                expect(pair.element) === observerTwo
            }
        }
    }
    
}
