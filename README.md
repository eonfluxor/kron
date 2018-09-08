[![CocoaPods compatible](https://img.shields.io/cocoapods/v/delay.svg)](#cocoapods) 
[![GitHub release](https://img.shields.io/github/release/eonfluxor/delay.svg)](https://github.com/eonfluxor/delay/releases) 
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg) 
![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg)

🎉 [Getting Started](#getting-started) 

## What is Delay?
__delay__ 
   
## Examples

Please review the test units for exhaustive implementation samples.

1. **Debouncer**

```
Delay.idle(1, key:"test", ctx: context){ (key,ctx) in
            expectation2.fulfill()
}
```

Using an object as the key:

```
let object = UIView()
Delay.idle(1, key:object, ctx: context){ (key,ctx) in
            expectation2.fulfill()
}
```

#### CocoaPods

If you use [CocoaPods][] to manage your dependencies, simply add
delay to your `Podfile`:

```
pod 'delay', '~> 3.0'
```

## Have a question?
If you need any help, please visit our [GitHub issues][]. Feel free to file an issue if you do not manage to find any solution from the archives.
