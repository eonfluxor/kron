//
//  DelayTests.swift
//  DelayTests
//
//  Created by hassan uriostegui on 9/7/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import XCTest
@testable import Delay

class DelayTests: XCTestCase {
    
    
    func testIdleWithContext() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        
        Delay.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Delay.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Delay.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation.fulfill()
            XCTAssert((ctx as! Int) == 90)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    
    func testDebounceWithContext() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        
        Delay.debounce(1, key:"test", ctx: context){ (key,ctx) in
            expectation.fulfill()
            XCTAssert((ctx as! Int) == 90)
        }
        Delay.debounce(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDebounceLast() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute once")
        let ignore = self.expectation(description: "execute ignored")
        ignore.isInverted = true
        
        
        Delay.debounceLast(1, key:"test"){ (key,ctx) in
            expectation.fulfill()
        }
        Delay.debounceLast(1, key:"test"){ (key,ctx) in
            ignore.fulfill()
        }
        Delay.debounceLast(1, key:"test"){ (key,ctx) in
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testWatchdog() {
        
        let expectation = self.expectation(description: "execute once")
        let ref:NSDictionary = ["foo":"bar"]
        
        Delay.watchDog(1, key:"test",ctx:ref){ (key,ctx) in
            expectation.fulfill()
            let aRef = ctx as? NSDictionary
            XCTAssert(ref == aRef)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testWatchdogCancel() {
        
        let expectation = self.expectation(description: "execute once")
        expectation.isInverted = true
        
        
        Delay.watchDog(1, key:"test"){ (key,ctx) in
            expectation.fulfill()
        }
        
        Delay.watchDogCancel(key:"test")
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testIdleWithRef() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        let ref:[String:Any] = [:]
        
        Delay.idle(1, key:ref, ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Delay.idle(1, key:ref, ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Delay.idle(1, key:ref, ctx: context){ (key,ctx) in
            expectation.fulfill()
            XCTAssert((ctx as! Int) == 90)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testContextRetain() {
        
        let expectation = self.expectation(description: "must release")
        let expectation2 = self.expectation(description: "fail")
        expectation2.isInverted=true
        
        var ref:NSObject? = NSObject()
        print(CFGetRetainCount(ref))
        Delay.idle(1, key:"test", ctx: ref){ (key,ctx) in
            print("reatin on closure \(CFGetRetainCount(ctx as CFTypeRef)))")
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0 ) {
               
                if(ctx == nil){
                    expectation.fulfill()
                }else{
                     print(CFGetRetainCount(ctx as CFTypeRef))
                    expectation2.fulfill()
                }
                
            }
        }
        
        ref = nil
        
        
        
        
        waitForExpectations(timeout: 100, handler: nil)
    }
    
}
