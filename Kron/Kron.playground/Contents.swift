//: Playground - noun: a place where people can play

import Cocoa

let context = "userTap"

class SomeClass{
    var timer:Timer?
    
    /// create timer
    func createTimer(){
        assert( timer == nil, "Please call cancelTimer first" )
        
        timer = Timer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(timerTick), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    // cancel timer
    func cancelTimer(){
        if let aTimer = timer {
            aTimer.invalidate()
        }
        
        timer = nil
    }
    
    // restart timer
    func restartTimer(){
        cancelTimer()
        createTimer()
    }
    
    /// handle callback
    @objc func timerTick(_ timer:Timer){
        timer.invalidate()
        //Do something
    }
}


Kron.debounce(timeOut:1.0, key:"updateUI", context: context){ (key,context) in
    
    if context = context {
        print(context as! String) // userTap
    }
    
}
