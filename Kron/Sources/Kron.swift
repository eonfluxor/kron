//
//  Kron.swift
//  Kron
//
//  Created by hassan uriostegui on 9/7/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX) || os(macOS)
import Cocoa
#endif


///**Kron** is a **NSTimer manager** offering **4 modes** through a unified api. Kron takes care of the involved implementation of NSTimers while ensuring a proper memory management with no extra effort:
///
///1. `Kron.debounce`: Calls immediatly and reject calls until time out elapses
///1. `Kron.debounceLast`: As `debounce` but also performs the last call after time out
///1. `Kron.idle`: Performs the last call after not being called during the timeout interval
///1. `Kron.watchdog`: As `idle` but allowing to be canceled with `watchDogCancel`
public class Kron: NSObject {
    
    class KronRef{
        weak var mutable:AnyObject?
        var immutable:Any?
        
        init(_ object:Any?){
            immutable = nil
            if let object = object{
                if Mirror(reflecting: object).displayStyle == .class {
                    mutable = object as AnyObject
                }
            }
            if mutable == nil{
               immutable = object
            }
        }
        

        func object()->Any?{
            if mutable != nil {
                return mutable
            }
            
            if immutable != nil {
                return immutable
            }
            return nil
        }
    }
    
    struct KronJob{
        let aKey:KronKey
        let action:KronClosure?
        let context:KronRef
    }
    
    enum KronMode{
        case debounce
        case idle
    }
    
    // MARK: VARS
    
    var timers:[String:Timer] = [:]
    let operationQueue:OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount=1
        return queue
    }()
    
    
    // MARK: SINGLETONS
    
    static let debounceLastTimer = Kron()
    static let idleTimer = Kron()
    static let debounceTimer = Kron()
    static let watchdogTimer = Kron()
    
    //MARK: - Core
    
    func _timer(_ aKey:KronKey,
                timeOut interval:Double,
                mode:KronMode,
                context:Any?,
                anAction:@escaping KronClosure){
        
        
        let key = self.key(aKey)
        var action = anAction
        
        if( mode == .debounce && !hasKey(key)){
            
            action(aKey, context)
            action = { (key,context) in } //dummie action to debounce
            
        }else if (mode == .debounce && hasKey(key)){
            
            return
            
        } else if (mode == .idle) {
            
            cancelTimer(key)
        }
        
        let ref = KronRef(context)
        let job = KronJob(aKey:aKey, action: action, context: ref)
        
        let timer = Timer(timeInterval: TimeInterval(interval), target: self, selector: #selector(timerTick), userInfo: job, repeats: false)
        self.timers[key] = timer
        
        RunLoop.main.add(timer, forMode: .commonModes)
        
    }
    
    //MARK: - lifecycle
    
    @objc func timerTick(_ timer:Timer){
        
       
        // TODO: sync this with self
        
        let job = timer.userInfo! as! KronJob
        
        let key = job.aKey
        self.takeTimer(key)
        
        let action = job.action
        let ref = job.context
        let context = ref.object()
        
        if let action = action {
            action(key,context)
        }
    }
    
    
    @discardableResult
    func cancelTimer(_ aKey:KronKey)->Bool{
        
        var result = true
        let aTimer = self.takeTimer(aKey)
        
        if let timer = aTimer {
            autoreleasepool{
                timer.invalidate()
            }
        }else{
            result = false
        }
        
        return result
    }

}

//MARK: Map
extension Kron{

    func key(_ key:Any)->String{
        if ((key as? String) != nil) {
            return key as! String
        }
        return "\(Unmanaged.passUnretained(key as AnyObject).toOpaque())"
    }
    
    
    func hasKey(_ aKey:Any)->Bool{
        let key = self.key(aKey)
        return self.timers.keys.contains(key)
    }
    
    
    @discardableResult
    func takeTimer(_ aKey:KronKey)->Timer?{
        //TODO: WE NEED TO MAKE THIS ATOMIC IN RELATION TO THE SETTER
        
        let key = self.key(aKey)
        let timer = timers[key]
        if (timer != nil) {
            timers.removeValue(forKey: key)
        }
        return timer
    }
}
