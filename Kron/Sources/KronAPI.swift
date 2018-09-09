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

public typealias KronKey = Any
public typealias KronClosure = (_ key:String,_ context:Any?)->Void


//MARK: - Static Debouncer
extension Kron{
    
    /// Manages a `debounce` and idle `idle` timer.
    /// The function will debounce actions as defined in `interval`
    ///
    ///
    /// - Parameters:
    ///   - interval: the time interval
    ///   - aKey: an String or Class
    ///   - ctx: any Struct or Class. (Internally wraped as a weak reference)
    ///   - action: closure called on timeout
    public static func debounceLast(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        action:@escaping KronClosure){
        
        debounceLastTimer.debounceLast(
            interval,
            key: aKey,
            ctx: ctx,
            action: action)
    }
    
    public static func debounce(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        action:@escaping KronClosure){
        
        debounceTimer.debounce(
            interval,
            key: aKey,
            ctx: ctx,
            action)
        
    }
}



// MARK: - Static Watchdog
extension Kron {
    
    public static func watchDog(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        action:@escaping KronClosure){
        
        watchdogTimer.watchDog(
            interval,
            key: aKey,
            ctx: ctx,
            action)
    }
    
    public static func watchDogCancel(key aKey:KronKey){
        watchdogTimer.watchDogCancel(key:aKey)
    }
    
}

// MARK: - Static Idle Timeout
extension Kron{
    public static func idle(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        action:@escaping KronClosure){
        
        idleTimer.idle(
            interval,
            key: aKey,
            ctx: ctx,
            action)
    }
}


//MARK: - Instance Debouncer
extension Kron{
    
    public func debounceLast(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        action:@escaping KronClosure){
        
        let key = self.key(aKey)
        let debounceKey = "debounce.\(key)"
        let idleKey = "idle.\(key)"
        
        debounce(   interval ,key:debounceKey   ,ctx:ctx, action)
        idle(     interval ,key:idleKey     ,ctx:ctx, action)
    }
    
    public func debounce(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               interval,
               mode: .debounce,
               ctx: ctx,
               anAction: action)
        
    }
}


//MARK: - Instance Watchdog
extension Kron{
    
    public func watchDog(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               interval,
               mode: .idle,
               ctx: ctx,
               anAction: action)
    }
    
    public func watchDogCancel(key aKey:KronKey){
        cancelTimer(aKey)
    }
}


//MARK: - Instance Idle Timeout
extension Kron{
    public func idle(
        _ interval:Double,
        key aKey:KronKey,
        ctx:Any? = nil,
        _ action:@escaping KronClosure){
        
        _timer(aKey,
               interval,
               mode: .idle,
               ctx: ctx,
               anAction: action)
    }
}