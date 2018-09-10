## Examples


Please review the test units for exhaustive implementation samples.

In all instances the timer will be reset by simply calling Kron with the same key. (See below `Static vs Instance` to learn more about the Static keyspace).
Kron
1. **Idle Timer**
    
```
Kron.idle(1, key:"keyStrokes"){ (key,ctx) in
      print("performed after 1 second of inactivity")
}
```
   
1. **Debouncer**

```
Kron.debounce(1, key:"Scroll"){ (key,ctx) in
      print("performed immediately and again no sooner than 1 second")
}
```

1. **Debouncer and perform last**

```
Kron.debounceLast(1, key:"Scroll"){ (key,ctx) in
      print("performed immediately and again no sooner than 1 second")
      print("also performs the last call after 1 second of inactivity")
}
```

1. **Watchdog**

```
Kron.watchDog(10, key:"ApiResponse"){ (key,ctx) in
      print("performed  after 10 seconds unless canceled")

}

...

// Called somewhere else to abort the timeOut
Kron.watchDogCancel("ApiResponse")

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

```
let myKron = Kron()
myKron( ...
```