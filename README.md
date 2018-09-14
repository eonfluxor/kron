 <p align="center"> 
    <img src="https://res.cloudinary.com/dmje5xfzh/image/upload/v1536538700/static/kron-logo.png" alt="alternate text">
 </p>

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/Delayed.svg)](#cocoapods) 
[![GitHub release](https://img.shields.io/github/release/eonfluxor/kron.svg)](https://github.com/eonfluxor/delay/releases) 
![Swift 4.0](https://img.shields.io/badge/Swift-4.1-orange.svg) 
![platforms](https://img.shields.io/cocoapods/p/Delayed.svg)
[![Build Status](https://travis-ci.org/eonfluxor/kron.svg?branch=master)](https://travis-ci.org/eonfluxor/kron)



# What is Kron?
**Kron** is a **reset-able Timers manager** offering **4 modes** through a unified api. Kron takes care of the involved implementation of reset-able Timers while ensuring a proper memory management with no extra effort:

1. `Kron.debounce`: Calls immediatly and reject calls until time out elapses
1. `Kron.debounceLast`: As `debounce` but also performs the last call after time out
1. `Kron.idle`: Performs the last call after not being called during the timeout interval
1. `Kron.watchdog`: As `idle` but allowing to be canceled with `watchDogCancel`

## CocoaPods

If you use `CocoaPods` to manage your dependencies, simply add
Kron to your `Podfile`:

```
pod 'Delayed', '> 2.2.2'
```

And then import the module

```
import Delayed
```


### Why Kron?


Creating a reset-able Timer requires a setup similar to this:

```swift

class SomeClass{
    var timer:Timer?
    
    /// create timer
    func createTimer(){
        assert( timer == nil, "Please call cancelTimer first" )
        
        timer = Timer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    // cancel timer
    func cancelTimer(){
        if let aTimer = timer {
            aTimer.invalidate()
        }
        
        timer = nil
    }
    
    // restart timer
    func restartTimer(){
        cancelTimer()
        createTimer()
    }
    
    /// handle callback
    @objc func timerTick(_ timer:Timer){
        timer.invalidate()
        //Do something
    }
}
```

### What about doing this in one line?

Kron takes care of all this setup by internally managing a map of Timers that can be accesed through a `resetKey`. Recursively calling with the same `resetKey` will cause that particular timer to reset in all modes.

```swift
Kron.idle(timeOut:1.0, resetKey:"updateUI"){ (key,context) in
     
}
```

So the main difference are

* Instead of returning a `Timer` instance, **Kron** manages the Timers internally through a [`KronKey` : `Timer`]  dictionary. This makes easy to call **Kron** from distant components or threads accesing the timers by their key value and in a single line.

* The `KronKey` can be etiher a `String` struct or `AnyObject` instance.  If an object is passed the key is inferred from the object's pointer. Calling the methods with the same key causes all timer modes to be reset.

* An optional `context` of `Any?` type can be provided and it's internally ***wrapped with a weak reference***  to prevent retain cycles. The context is then optionally passed to the `timeOut` closure. 
       
## Practical Applications

### Debounce Scroll

This example will ensure to update the UI only every second during user scroll. Additionally using `debounceLast` will ensure to apply the last call on timeOut. This will guarante the last event will be performed.  (You cn alsu use `debounce` for traditional debouncing.

```swift
func didScroll(){
	Kron.debounceLast(timeOut: 1, resetKey: "scroll") { (keu, context) in
   		//updateUI     
	}
}
```

### Idleand Ensure Context

This example will save a document only if the user hasn't typed in 5 seconds. In the timeOut closure we check that the `KronKey` is equal to the currentDocumet otherwise we abort the save action.


```swift

var currentDocument:NSObject;

func textViewDidChange(){
	autoSave()
}

func autoSave(){
    Kron.idle(timeOut:10.0, resetKey:self.currentDocument){ [weak self] (key,context) in
          
        let aDocument = key as? NSObject
        guard aDocument == self?.currentDocument else{
            return
        }
        self?.saveNow()
    }
}

func saveNow(){
  //save only if current document is still active
}
```

### Watchdog

The following example shows how to add a watchdog for different Api Requests.


```swift
func startApiRequest(_ endPointURL:String){
    
    let watchdogkey = "ApiRequest\(endPointURL)"
    
    Kron.watchDog(timeOut:10.0, resetKey:watchdogkey){ (key,context) in
        // retry or something else?
        assert(false, "print api is not responding!")
    }
    
    SomeClass.loadApi(endPointURL){
        
        Kron.watchDogCancel(watchdogkey)
        
    }
}
```


## Documentation

Self-generated documentation using jazzy and hosted in github available here:

[Documentation](https://eonfluxor.github.io/kron/)

   
   
## Gists

Please review the test units for exhaustive implementation samples.

In all instances the timer will be reset by simply calling Kron with the same key. (See below `Static vs Instance` to learn more about the Static keyspace).

* **Idle Timer**


```swift
Kron.idle(timeOut:1.0, resetKey:"keyStrokes"){ (key,context) in
      print("performed after 1 second of inactivity")
}
```

* **Debouncer**

```swift
Kron.debounce(timeOut:1.0, resetKey:"Scroll"){ (key,context) in
      print("performed immediately and again no sooner than 1 second")
}
```

* **Debouncer and perform last**

```swift
Kron.debounceLast(timeOut:1.0, resetKey:"Scroll"){ (key,context) in
      print("performed immediately and again no sooner than 1 second")
      print("also performs the last call after 1 second of inactivity")
}
```

* **Watchdog**

```swift
Kron.watchdog(timeOut:10.0, resetKey:"ApiResponse"){ (key,context) in
      print("performed  after 10 seconds unless canceled")

}

...

// Called somewhere else to abort the timeOut
Kron.watchdogCancel("ApiResponse")

```

### Satic vs Instance

You can use the provided static functions. Internally **Kron** manages 4 singletons to prevent key collisions between the different modes:

```
//Debouncer
Kron.debounce

//Debouncing Last
Kron.debounceLast

//Idle
Kron.idle

//Watchdog
Kron.watchdog
```

Optionally you can instantiate **Kron** to manage your own keyspace in that given intance.

```swift
let myKron = Kron()
myKron( ...
```

## Have a question?
If you need any help, please visit our GitHub issues. Feel free to file an issue if you do not manage to find any solution from the archives.

You can also reach us at: 

`eonfluxor@gmail.com `

## About

**Kron** was originally built by [Hassan Uriostegui](http://linkedin.com/in/hassanvfx) as an objective-C framework. It's now released as a swift open source framework under the **Eonflux** collective. Check our other projects and join our *eon flux of innovaton* !
