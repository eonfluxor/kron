//
//  Delay.swift
//  Delay
//
//  Created by hassan uriostegui on 9/7/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#else
import Cocoa
#endif


/// Delay offers 3 timer modes: 
public class Delay: NSObject {
    
    class DelayRef{
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
    
    struct DelayJob{
        let key:String = ""
        let action:DelayClosure?
        let ctx:DelayRef
    }
    
    enum DelayMode{
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
    
    static let debounceLastTimer = Delay()
    static let idleTimer = Delay()
    static let debounceTimer = Delay()
    static let watchdogTimer = Delay()
    
    //MARK: - Core
    
    func _timer(_ aKey:DelayKey,
                            _ interval:Double,
                            mode:DelayMode,
                            ctx:Any?,
                            anAction:@escaping DelayClosure){
        
        
        let key = self.key(aKey)
        var action = anAction
        
        if( mode == .debounce && !hasKey(key)){
            
            action(key, ctx)
            action = { (key,ctx) in } //dummie action to debounce
            
        }else if (mode == .debounce && hasKey(key)){
            
            return
            
        } else if (mode == .idle) {
            
            cancelTimer(key)
        }
        
        let ref = DelayRef(ctx)
        let job = DelayJob(action: action, ctx: ref)
        
        let timer = Timer(timeInterval: TimeInterval(interval), target: self, selector: #selector(timerTick), userInfo: job, repeats: false)
        self.timers[key] = timer
        
        RunLoop.main.add(timer, forMode: .commonModes)
        
    }
    
    //MARK: - lifecycle
    
    @objc func timerTick(_ timer:Timer){
        
        // TODO: sync this with self
        
        let job = timer.userInfo! as! DelayJob
        
        let key = job.key
        self.takeTimer(key)
        
        let action = job.action
        let ref = job.ctx
        let ctx = ref.object()
        
        if let action = action {
            action(key,ctx)
        }
    }
    
    
    @discardableResult
    func cancelTimer(_ aKey:DelayKey)->Bool{
        
        var result = true
        
        var aTimer = self.takeTimer(aKey)
        
        if let timer = aTimer {
            timer.invalidate()
        }else{
            result = false
        }
        
        autoreleasepool{
            aTimer = nil
        }
        
        return result
    }

}

//MARK: Map
extension Delay{

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
    func takeTimer(_ aKey:DelayKey)->Timer?{
        //TODO: WE NEED TO MAKE THIS ATOMIC IN RELATION TO THE SETTER
        
        let key = self.key(aKey)
        let timer = timers[key]
        if (timer != nil) {
            timers.removeValue(forKey: key)
        }
        return timer
    }
}
