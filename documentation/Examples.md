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
