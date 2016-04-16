//
//  Trial.swift
//  LineTip
//
//  Created by Artur Schäfer on 30.11.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

/// Represents a trial of the line detection test
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
    var missedLinePositionList = [CGPoint]()
    
    override init(){
        print("Trial: init")
        self.timeStamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
    }
    
    /// counts trial time
    func startCountingTime() {
        if(!self.hasStarted()){
            print("Trial: startCountingTime: counting started")
            self.startTime = CFAbsoluteTimeGetCurrent()
        }
        else{
            print("Trial: startCountingTime: not started, beacause already counting")
        }
    }
    
    /// stop counting trial time
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
    
    func toString() -> String {
        let ret =  "\("timestamp".translate()): " + "\(self.timeStamp)" + "\r\n" + "\("hits".translate()): " + "\(self.hits)" + "\r\n" + "\("misses".translate()): " + "\(self.fails)" + "\r\n" + "\("duration".translate()): " + "\(self.duration.getStringAsHoursMinutesSeconds())" + "\r\n"
        return ret
    }
    
    /// add a missed touch with its positions to trial
    func addMissedTouchPosition(lastTouchPosition: CGPoint) { //-> Array<CGPoint>
        let isNotXEquals0AndYEquals0 = (lastTouchPosition.x != 0) && (lastTouchPosition.y != 0)
        if(isNotXEquals0AndYEquals0){
           self.missedLinePositionList.append(lastTouchPosition)
        }
    }
    
    /// returns a tendecy
    func getTendency() -> String {
        var topLeft = 0
        var topRight = 0
        var downLeft = 0
        var downRight = 0
        
        for position in missedLinePositionList {
            let currentTendency = getTendencyNameByPosition(position)
            if (currentTendency == "topRight") {
                topRight += 1
            }
            else if (currentTendency == "topLeft") {
                topLeft += 1
            }
            else if (currentTendency == "downLeft") {
                downLeft += 1
            }
            else {
                downRight += 1
            }
        }
        
        
        return getMaxOfFour(topLeft, topRight: topRight, downLeft: downLeft, downRight: downRight)
    }
    
    /// returns a tendecy for a point
    func getMaxOfFour(topLeft: Int, topRight: Int, downLeft: Int, downRight: Int) -> String {
        var toReturn = ""
        let numbers = [topLeft, topRight, downLeft, downRight]
        let max = numbers.maxElement()
        
        /*COUNT
        -hat3Maxima : Bool -> none
        -hat2Maxima+-3Abweichung: Bool
            -andere sind min. 5 kleiner
            -welche sind die zwei Maxima? downLeft and down right? --> Tendez: down
        -hat1Maximum+-Abweichung
        
        let arr = ["FOO", "FOO", "BAR", "FOOBAR"]
        var counts:[String:Int] = [:]
        
        for item in arr {
            counts[item] = (counts[item] ?? 0) + 1
        }
        
        println(counts)  // "[BAR: 1, FOOBAR: 1, FOO: 2]"
        
        for (key, value) in counts {
            println("\(key) occurs \(value) time(s)")
        }
        */
        
        if max == 0 {
            return "none"
        }
        
        var index = 0
        for (element) in numbers {
            if (max == element) {
                break
            }
            print("Item \(index): \(element)")
            index += 1
        }
        
        if(index == 0) {
            toReturn = "topLeft"
        }
        else if (index == 1) {
            toReturn = "topRight"
        }
        else if (index == 2) {
            toReturn = "downLeft"
        }
        else  {
            toReturn = "downRight"
        }
        
        return toReturn
    }
    
    /// returns a tendecy for a point
    func getTendencyNameByPosition(position: CGPoint) -> String {
            var toReturn = ""
            if position.y >= 0 {
                toReturn += "top"
            }
            else {
                toReturn += "down"
            }
            if position.x >= 0 {
                toReturn += "Left"
            }
            else {
                toReturn += "Right"
            }
        return toReturn
    }
    
    
    
    
}
