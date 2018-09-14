//
//  KronTests.swift
//  KronTests
//
//  Created by hassan uriostegui on 9/7/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import XCTest



class KronTests: XCTestCase {
    
 
    
    
    func test(){
        let context = "userTap"
        Kron.debounce(timeOut:1.0, resetKey:"updateUI", context: context){ (key,context) in
            
            print(context as! String) // userTap
            
        }
    }
    
    func testKeyString() {
        
        let expectation = self.expectation(description: "execute once")
        
        Kron.idle(timeOut:1, resetKey:"test"){ (key,context) in
            XCTAssert((key as! String) == "test")
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testKeyObject() {
        
        let expectation = self.expectation(description: "execute once")
        
        let aKey = NSObject()
        Kron.idle(timeOut:1, resetKey:aKey){ (key,context) in
            XCTAssert((key as! NSObject) == aKey)
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testIdleWithContext() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        
        Kron.idle(timeOut:1, resetKey:"test", context: context){ (key,context) in
            expectation2.fulfill()
        }
        Kron.idle(timeOut:1, resetKey:"test", context: context){ (key,context) in
            expectation2.fulfill()
        }
        Kron.idle(timeOut:1, resetKey:"test", context: context){ (key,context) in
            expectation.fulfill()
            XCTAssert((context as! Int) == 90)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    
    func testDebounceWithContext() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        
        Kron.debounce(timeOut: 1, resetKey:"test", context: context){ (key,context) in
            expectation.fulfill()
            XCTAssert((context as! Int) == 90)
        }
        Kron.debounce(timeOut: 1, resetKey:"test", context: context){ (key,context) in
            expectation2.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDebounceLast() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute once")
        let ignore = self.expectation(description: "execute ignored")
        ignore.isInverted = true
        
        
        Kron.debounceLast(timeOut:1, resetKey:"test"){ (key,context) in
            expectation.fulfill()
        }
        Kron.debounceLast(timeOut:1, resetKey:"test"){ (key,context) in
            ignore.fulfill()
        }
        Kron.debounceLast(timeOut:1, resetKey:"test"){ (key,context) in
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testwatchDog() {
        
        let expectation = self.expectation(description: "execute once")
        let ref:NSDictionary = ["foo":"bar"]
        
        Kron.watchDog(timeOut:1, resetKey:"test",context:ref){ (key,context) in
            expectation.fulfill()
            let aRef = context as? NSDictionary
            XCTAssert(ref == aRef)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testWatchdogCancel() {
        
        let expectation = self.expectation(description: "execute once")
        expectation.isInverted = true
        
        
        Kron.watchDog(timeOut:1, resetKey:"test"){ (key,context) in
            expectation.fulfill()
        }
        
        Kron.watchDogCancel(key:"test")
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testIdleWithRef() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute ignored")
        expectation2.isInverted = true
        
        let context:Int = 90
        let ref:[String:Any] = [:]
        
        Kron.idle(timeOut:1, resetKey:ref, context: context){ (key,context) in
            expectation2.fulfill()
        }
        Kron.idle(timeOut:1, resetKey:ref, context: context){ (key,context) in
            expectation2.fulfill()
        }
        Kron.idle(timeOut:1, resetKey:ref, context: context){ (key,context) in
            expectation.fulfill()
            XCTAssert((context as! Int) == 90)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testContextRetain() {
        
        let expectation = self.expectation(description: "must release")
        let expectation2 = self.expectation(description: "fail")
        expectation2.isInverted=true
        
        var ref:NSObject? = NSObject()
        print(CFGetRetainCount(ref))
        Kron.idle(timeOut:1, resetKey:"test", context: ref){ (key,context) in
            print("reatin on closure \(CFGetRetainCount(context as CFTypeRef)))")
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
               
                if(context == nil){
                    expectation.fulfill()
                }else{
                     print(CFGetRetainCount(context as CFTypeRef))
                    expectation2.fulfill()
                }
                
            }
        }
        
        ref = nil
        waitForExpectations(timeout: 4, handler: nil)
    }
    
}
