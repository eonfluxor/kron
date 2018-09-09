[![CocoaPods compatible](https://img.shields.io/cocoapods/v/delay.svg)](#cocoapods) 
[![GitHub release](https://img.shields.io/github/release/eonfluxor/delay.svg)](https://github.com/eonfluxor/delay/releases) 
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg) 
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)

# What is Delay?
**Delay** is a **NSTimer manager** offering **4 modes** through a unified api. Delay takes care of the involved implementation of NSTimers while ensuring a proper memory management with no extra effort:

1. `Delay.debounce`: Calls immediatly and reject calls until time out elapses
1. `Delay.debounceLast`: As `debounce` but also performs the last call after time out
1. `Delay.idle`: Performs the last call after not being called during the timeout interval
1. `Delay.watchdog`: As `idle` but allowing to be canceled with `watchDogCancel`

### Why Delay?


* Instead of returning a timer object, **Delay** manages the Timer instances internally through a [`DelayKey` : `Timer`]  dictionary. This makes easy to call **Delay** from distant components or threads accesing the timers by their key value.


* The `DelayKey` can be etiher a `String` struct or `AnyObject` instance.  If an object is passed the key is inferred from the object's pointer. Calling the methods with the same key causes all timer modes to be reset.


* As the intention is to facilitate calling **Delay** from distant implementations you can optional pass a context value `ctx`. A context can be `Any` struct or class instance and it's internally ***wrapped with a weak reference***  to prevent retain cycles. The context is then optionally passed to the timeOut closure.


### Gist samples

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

## Documentation

Self-generated documentation using jazzy and hosted in github available here:

[Documentation](https://htmlpreview.github.io/?https://raw.githubusercontent.com/eonfluxor/delay/master/docs/index.html)

## CocoaPods

If you use [CocoaPods][] to manage your dependencies, simply add
delay to your `Podfile`:

```
pod 'delay', '~> 3.0'
```
   
## More Examples

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

You can use the provided static functions. Internally **Delay** manages 4 singletons to prevent key collisions between the different modes:

```
//Debouncer
Delay.debounce

//Debouncing Last
Delay.debounceLast

//Idle
Delay.idle

//Watchdog
Delay.watchdog
```

Optionally you can instantiate **Delay** to manage your own keyspace in that given intance.

```
let myDelay = Delay()
myDelay( ...
```

## Have a question?
If you need any help, please visit our GitHub issues. Feel free to file an issue if you do not manage to find any solution from the archives.

You can also reach us at: 

`eonfluxor@gmail.com `

## About

**Delay** was originally built by [Hassan Uriostegui](http://linkedin.com/in/hassanvfx) as an objective-C framework. It's now released as a swift open source framework under the **Eonflux** collective. Check our other projects and join our *eon flux of innovaton* !
