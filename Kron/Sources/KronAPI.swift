//
//  KronPublic.swift
//  Kron
//
//  Created by hassan uriostegui on 9/8/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX) || os(macOS)
import Cocoa
#endif

/// Used to inderectly store and access the Timer instance. It can be an `String` or `AnyClass`. Instance references are internally wrapped with optional weak pointers
public typealias KronKey = Any
/// Defines the closure to be performed on timeout.
public typealias KronClosure = (_ key:KronKey,_ context:Any? )->Void


//MARK: - Static Debouncer
extension Kron{
    
    /// Creates both a `debounce` and idle `idle` timer.
    /// * The function will debounce actions as defined in `interval`
    /// * Additionally will ensure to perform the last call after timeout
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public static func debounceLast(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        action:@escaping KronClosure){
        
        debounceLastTimer.debounceLast(
            timeOut: interval,
            key: aKey,
            context: context,
            action: action)
    }
    
    /// Creates a `debounce` timer.
    /// * The function will debounce actions as defined in `interval`
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public static func debounce(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        action:@escaping KronClosure){
        
        debounceTimer.debounce(
            timeOut: interval,
            key: aKey,
            context: context,
            action)
        
    }
}



// MARK: - Static Watchdog
extension Kron {
    
    /// Creates a `watchdog` timer.
    /// * Use `watchdogCancel` to early abort the timer.
    /// * The function will be called after timeout.
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public static func watchDog(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        action:@escaping KronClosure){
        
        watchdogTimer.watchDog(
            timeOut: interval,
            key: aKey,
            context: context,
            action)
    }
    
    /// Used to cancel a watchdog timer
    ///
    /// - Parameter aKey: any active timer `KronKey`
    public static func watchDogCancel(key aKey:KronKey){
        watchdogTimer.watchDogCancel(key:aKey)
    }
    
}

// MARK: - Static Idle Timeout
extension Kron{
    
    /// Creates an `idle` timer.
    /// * The function will be called after timeout.
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public static func idle(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        action:@escaping KronClosure){
        
        idleTimer.idle(
            timeOut: interval,
            key: aKey,
            context: context,
            action)
    }
}


//MARK: - Instance Debouncer
extension Kron{
    
    /// Creates both a `debounce` and idle `idle` timer.
    /// * The function will debounce actions as defined in `interval`
    /// * Additionally will ensure to perform the last call after timeout
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public func debounceLast(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        action:@escaping KronClosure){
        
        let key = self.key(aKey)
        let debounceKey = "debounce.\(key)"
        let idleKey = "idle.\(key)"
        
        debounce(timeOut: interval,
                 key:debounceKey,
                 context:context,
                 action)
        
        idle(timeOut: interval,
             key:idleKey,
             context:context,
             action)
    }
    
    
    /// Creates a `debounce` timer.
    /// * The function will debounce actions as defined in `interval`
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public func debounce(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               timeOut:interval,
               mode: .debounce,
               context: context,
               anAction: action)
        
    }
}


//MARK: - Instance Watchdog
extension Kron{
    
    /// Creates a `watchdog` timer.
    /// * Use `watchdogCancel` to early abort the timer.
    /// * The function will be called after timeout.
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public func watchDog(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               timeOut: interval,
               mode: .idle,
               context: context,
               anAction: action)
    }
    
    
    /// Used to cancel a watchdog timer
    ///
    /// - Parameter aKey: any active timer `KronKey`
    public func watchDogCancel(key aKey:KronKey){
        cancelTimer(aKey)
    }
}


//MARK: - Instance Idle Timeout
extension Kron{
    
    /// Creates an `idle` timer.
    /// * The function will be called after timeout.
    /// * Timer will be reset if called again with the same `KronKey`
    ///
    /// - Parameters:
    ///   - interval: the timeOut interval
    ///   - aKey: an String or Class
    ///   - context: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public func idle(
        timeOut interval:Double,
        key aKey:KronKey,
        context:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               timeOut: interval,
               mode: .idle,
               context: context,
               anAction: action)
    }
}
