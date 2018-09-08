[![CocoaPods compatible](https://img.shields.io/cocoapods/v/delay.svg)](#cocoapods) 
[![GitHub release](https://img.shields.io/github/release/eonfluxor/delay.svg)](https://github.com/eonfluxor/delay/releases) 
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg) 
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)

# What is Delay?
Delay is an Manager offering 4 convenient Timer modes through a friendly interface. Delay takes care of the invovled NSTimer implementation and lifecycle. 

1. `debounce` Calls immediatly and reject calls until time out elapses
1. `debounceLast` As `debounce` but also performs the last call after time out
1. `idle` Performs the last call after not being called during the timeout interval
1. `watchdog` As `idle` but allowing to be canceled with `watchDogCancel`

### Why Delay?

Instead of returning a timer instance, Delay manages the Timer instances internally through a `DelayKey` -> `Timer` dictionary. This makes easy to call delay from distant components or threads accesing the timers by their key value 

The `DelayKey` can be etiher an `String` struct or `AnyObject` instance.  If an object is passed the key is inferred from the object's pointer.

As the intention is to facilitate calling delay from distant implementations you can optional pass a context `ctx` value. A context can be `Any` struct or class instance and it's internally wrapped with a weak reference to prevent retain cycles. The context is then optionally passed to the timeOut closure.


```
Delay.idle(1, key:"updateUI"){ (key,ctx) in
            //
}
```

```
let context = 'userTap'
Delay.idle(1, key:"updateUI", ctx: context){ (key,ctx) in
       print(ctx as! String) // userTap
}
```

```
//self.currentModel should be an AnyObject instance
Delay.idle(1, key:self.currentModel){ (key,ctx) in
            expectation2.fulfill()
}
```

## CocoaPods

If you use [CocoaPods][] to manage your dependencies, simply add
delay to your `Podfile`:

```
pod 'delay', '~> 3.0'
```
   
## Examples

Please review the test units for exhaustive implementation samples.

In all instances the timer will be reset by simply calling delay with the same key. (See below `Static vs Instance` to learn more about the Static keyspace).

1. **Idle Timer**
    
```
Delay.idle(1, key:"keyStrokes"){ (key,ctx) in
      print("performed after 1 second of inactivity")
}
```
   
1. **Debouncer**

```
Delay.debounce(1, key:"Scroll"){ (key,ctx) in
      print("performed immediately and again no sooner than 1 second")
}
```

1. **Debouncer and perform last**

```
Delay.debounceLast(1, key:"Scroll"){ (key,ctx) in
      print("performed immediately and again no sooner than 1 second")
      print("also performs the last call after 1 second of inactivity")
}
```

1. **Watchdog**

```
Delay.wachtDog(10, key:"ApiResponse"){ (key,ctx) in
      print("performed  after 10 seconds unless canceled")

}

...

// Called somewhere else to abort the timeOut
Delay.wachtDogCancel("ApiResponse")

```

### Satic vs Instance

You can use the provided static functions. Internally the class manages 3 singletons to prevent key collisions between the three different modes:

```
//Debouncer
Delay.debounce
Delay.debounceLast

//Idle
Delay.idle

//Watchdog
Delay.watchdog
```

Optionally you can instantiate Delay:

```
let delay = Delay()
delay.debounce( ...
```

## Have a question?
If you need any help, please visit our [GitHub issues][]. Feel free to file an issue if you do not manage to find any solution from the archives.
