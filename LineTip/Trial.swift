//
//  Trial.swift
//  LineTip
//
//  Created by Artur Schäfer on 30.11.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class Trial: NSObject {
    var hits : Int = 0
    var fails : Int = 0
    var overflowCounter : Int = 0
    var timeStamp: String
    var startTime: CFAbsoluteTime!
    
    override init(){
        self.timeStamp = "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    
    func startCountingTime() {
        if(!self.hasStarted()){
            self.startTime = CFAbsoluteTimeGetCurrent()
        }
    }
    
    func stopCountingTime() -> Double {
        var duration = -1.0
        if((self.startTime) != nil){
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            duration = round(elapsedTime)
            print("duration: \(elapsedTime) und als sek: \(duration)")
        }
        else{
            print("WARNING! Trials starttime not initialized!")
        }
        return duration
    }

    func countMiss() {
        self.fails++
    }
    
    func countHit() {
        self.hits++
        self.overflowCounter++
    }
    
    func hasStarted() -> Bool {
        let ret =   ((self.hits != 0) && (self.fails != 0))
        print(ret)
        return ret
    }
    
    //bullshit methods
    var count = 0
    func updateTime() {
        count++
        let seconds = count % 60
        let minutes = (count / 60) % 60
        let hours = count / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        
        var text: String
        if hours > 0 {
            text = "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            text = "\(strMinutes):\(strSeconds)"
        }
        print(text)
    }
    
    func getTimeBySec(totalSeconds: Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        
        if hours > 0 {
            return "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            return "\(strMinutes):\(strSeconds)"
        }
    }
    
    
    
}
