
## Examples

### Debounce Scroll

This example will ensure to update the UI only every second during user scroll. Additionally using `debounceLast` will ensure to apply the last call on timeOut. This will guarante the last event will be performed.  (You cn alsu use `debounce` for traditional debouncing.

```swift
func didScroll(){
	Kron.debounceLast(timeOut: 1, resetKey: "scroll") { (keu, context) in
   		//updateUI     
	}
}
```

### Ensure Context

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
