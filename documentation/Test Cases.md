## Test Cases

The following tests cover 100% of the code. They may give you more ideas on how to implement Kron.

```
import XCTest

class KronTests: XCTestCase {
    
    func testKeyString() {
        
        let expectation = self.expectation(description: "execute once")
        
        Kron.idle(1, key:"test"){ (key,ctx) in
            XCTAssert((key as! String) == "test")
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testKeyObject() {
        
        let expectation = self.expectation(description: "execute once")
        
        let aKey = NSObject()
        Kron.idle(1, key:aKey){ (key,ctx) in
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
        
        Kron.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Kron.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Kron.idle(1, key:"test", ctx: context){ (key,ctx) in
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
        
        Kron.debounce(1, key:"test", ctx: context){ (key,ctx) in
            expectation.fulfill()
            XCTAssert((ctx as! Int) == 90)
        }
        Kron.debounce(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDebounceLast() {
        
        let expectation = self.expectation(description: "execute once")
        let expectation2 = self.expectation(description: "execute once")
        let ignore = self.expectation(description: "execute ignored")
        ignore.isInverted = true
        
        
        Kron.debounceLast(1, key:"test"){ (key,ctx) in
            expectation.fulfill()
        }
        Kron.debounceLast(1, key:"test"){ (key,ctx) in
            ignore.fulfill()
        }
        Kron.debounceLast(1, key:"test"){ (key,ctx) in
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testWatchdog() {
        
        let expectation = self.expectation(description: "execute once")
        let ref:NSDictionary = ["foo":"bar"]
        
        Kron.watchDog(1, key:"test",ctx:ref){ (key,ctx) in
            expectation.fulfill()
            let aRef = ctx as? NSDictionary
            XCTAssert(ref == aRef)
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testWatchdogCancel() {
        
        let expectation = self.expectation(description: "execute once")
        expectation.isInverted = true
        
        
        Kron.watchDog(1, key:"test"){ (key,ctx) in
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
        
        Kron.idle(1, key:ref, ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Kron.idle(1, key:ref, ctx: context){ (key,ctx) in
            expectation2.fulfill()
        }
        Kron.idle(1, key:ref, ctx: context){ (key,ctx) in
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
        Kron.idle(1, key:"test", ctx: ref){ (key,ctx) in
            print("reatin on closure \(CFGetRetainCount(ctx as CFTypeRef)))")
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
               
                if(ctx == nil){
                    expectation.fulfill()
                }else{
                     print(CFGetRetainCount(ctx as CFTypeRef))
                    expectation2.fulfill()
                }
                
            }
        }
        
        ref = nil
        waitForExpectations(timeout: 4, handler: nil)
    }
    
}
```