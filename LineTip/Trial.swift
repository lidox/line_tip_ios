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
    var duration: Double = 0
    var userName: String = ""
    var isSelectedForStats: Bool = true
    var creationDate = NSDate()
    
    override init(){
        print("Trial: init")
        self.timeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }
    
    
    func startCountingTime() {
        if(!self.hasStarted()){
            print("Trial: startCountingTime: counting started")
            self.startTime = CFAbsoluteTimeGetCurrent()
        }
        else{
            print("Trial: startCountingTime: not started, beacause already counting")
        }
    }
    
    func stopCountigTime() -> Double {
        var duration = -1.0
        if((self.startTime) != nil){
            let elapsedTime = CFAbsoluteTimeGetCurrent() - startTime
            duration = round(elapsedTime)
            self.duration = round(elapsedTime)
            print("duration: \(elapsedTime) und als sek: \(duration)")
        }
        else{
            print("WARNING! Trials starttime not initialized!")
        }
        return duration
    }

    func countMiss() {
        print("Trial: countMiss")
        self.fails++
    }
    
    func countHit() {
        print("Trial: countHit")
        self.hits++
        self.overflowCounter++
    }
    
    func hasStarted() -> Bool {
        let ret =   ((self.hits != 0) || (self.fails != 0))
        print("Trial: hasStarted =\(ret)")
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
    
    func toString() -> String {
        let ret =  "\("timestamp".translate()): " + "\(self.timeStamp)" + "\r\n" + "\("hits".translate()): " + "\(self.hits)" + "\r\n" + "\("misses".translate()): " + "\(self.fails)" + "\r\n" + "\("duration".translate()): " + "\(self.duration.getStringAsHoursMinutesSeconds())" + "\r\n"
        return ret
    }
    
    
    
}
