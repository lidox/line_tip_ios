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
    var duration: String = ""
    
    override init(){
        self.timeStamp = "\(NSDate().timeIntervalSince1970 * 1000)"
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
    
    func countMiss() {
        self.fails++
    }
    
    func countHit() {
        self.hits++
        self.overflowCounter++
    }
    
    func hasStarted() -> Bool {
        return  (self.hits != 0 && self.fails != 0)
    }
    
}
