<p align="center">
	<!-- <a href="https://github.com/eonfluxor/delay/"><img src="Logo/PNG/logo.png" alt="delay" /></a><br /><br /> -->
	Delay Timers Made Easy.<br /><br />
	<!-- <a href="http://eonfluxor.io/delay/docs/latest/"><img src="Logo/PNG/Docs.png" alt="Latest Delay Documentation" width="143" height="40" /></a> <a href="http://eonfluxor.io/slack/"><img src="Logo/PNG/JoinSlack.png" alt="Join the delay Slack community." width="143" height="40" /></a> -->
</p>
<!-- <br /> -->


<!-- [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)  -->
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/delay.svg)](#cocoapods) 
<!-- [![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](#swift-package-manager)  -->
[![GitHub release](https://img.shields.io/github/release/eonfluxor/delay.svg)](https://github.com/eonfluxor/delay/releases) 
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg) 
<!-- ![platforms](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-lightgrey.svg) -->

<!-- 🎉 [Getting Started](#getting-started) 🚄 [Release Roadmap](#release-roadmap) -->



## What is Delay?
__delay__ 

## Getting Started

1. **[Topic][]**
  
   text [`Link`][], [`Link`][], [`Link`][] and [`Link`][].
   
## Examples

1. **Title**

     text [_UI Examples_ playground][], which demonstrates:
     * one.
     * two.

1. **[Online Searching][]**

## Advanced Topics

1. **[eonfluxor][]**
   
   Bindings and reactive extensions for Cocoa and Cocoa Touch frameworks are offered separately as eonfluxor.

1. **[API Reference][]**

1. **[API Contracts][]**

   Contracts of the delay primitives, Best Practices with delay, and Guidelines on implementing custom operators.

1. **[Debugging Techniques][]**

## Installation

delay supports macOS 10.9+, iOS 8.0+, watchOS 2.0+, tvOS 9.0+ and Linux.

```
github "eonfluxor/delay" ~> 3.0
```

#### CocoaPods

If you use [CocoaPods][] to manage your dependencies, simply add
delay to your `Podfile`:

```
pod 'delay', '~> 3.0'
```
## Playground

We also provide a great Playground, so you can get used to eonfluxor's operators. In order to start using it:

 1. Clone the delay repository.
 1. Retrieve the project dependencies using one of the following terminal commands from the delay project root directory:
     - `git submodule update --init --recursive` **OR**, if you have [Carthage][] installed    
     - `carthage checkout`
 1. Open `delay.xcworkspace`
 1. Build `Result-Mac` scheme
 1. Build `delay-macOS` scheme
 1. Finally open the `delay.playground`
 1. Choose `View > Show Debug Area`

## Have a question?
If you need any help, please visit our [GitHub issues][] or [Stack Overflow][]. Feel free to file an issue if you do not manage to find any solution from the archives.

## Release Roadmap
**Current Stable Release:**<br />[![GitHub release](https://img.shields.io/github/release/eonfluxor/delay.svg)](https://github.com/eonfluxor/delay/releases)

### Plan of Record
#### ABI stability release
delay is expected to declare library ABI stability when Swift rolls out resilence support. Until then, delay would incrementally adopt new language features that help move towards to goal. The ETA is Swift 5.

[Core Reactive Primitives]: Documentation/ReactivePrimitives.md
[Basic Operators]: Documentation/BasicOperators.md
[How does delay relate to RxSwift?]: Documentation/RxComparison.md
[API Contracts]: Documentation/APIContracts.md
[API Reference]: http://eonfluxor.io/delay/docs/latest/
[Debugging Techniques]: Documentation/DebuggingTechniques.md
[Online Searching]: Documentation/Example.OnlineSearch.md
[_UI Examples_ playground]: https://github.com/eonfluxor/delay/blob/master/delay-UIExamples.playground/Pages/ValidatingProperty.xcplaygroundpage/Contents.swift

[`Action`]: Documentation/ReactivePrimitives.md#action-a-serialized-worker-with-a-preset-action
[`SignalProducer`]: Documentation/ReactivePrimitives.md#signalproducer-deferred-work-that-creates-a-stream-of-values
[`Signal`]: Documentation/ReactivePrimitives.md#signal-a-unidirectional-stream-of-events
[`Property`]: Documentation/ReactivePrimitives.md#property-an-observable-box-that-always-holds-a-value

[eonfluxor]: https://github.com/eonfluxor/eonfluxor/#readme

[Carthage]: https://github.com/Carthage/Carthage/#readme
[CocoaPods]: https://cocoapods.org/
[submodule]: https://git-scm.com/docs/git-submodule

[GitHub issues]: https://github.com/eonfluxor/delay/issues?q=is%3Aissue+label%3Aquestion+
[Stack Overflow]: http://stackoverflow.com/questions/tagged/reactive-cocoa

[Looking for the Objective-C API?]: https://github.com/eonfluxor/ReactiveObjC/#readme
[Still using Swift 2.x?]: https://github.com/eonfluxor/eonfluxor/tree/v4.0.0
