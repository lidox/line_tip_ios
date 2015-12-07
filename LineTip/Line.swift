//
//  Line.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import Foundation

class Line: NSObject {
    var x1 : Int = 0
    var y1 : Int = 0
    var x2: Int = 0
    var y2: Int = 0
    
    init(x1: Int, y1: Int, x2: Int, y2: Int){
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }
    
    func getLenght() -> Double {
        let x1 = Double(self.x1)
        let y1 = Double(self.y1)
        let x2 = Double(self.x2)
        let y2 = Double(self.y2)
        let numerator = (x2-x1) * (x2-x1)
        let denominator = (y2-y1) * (y2-y1)
        let result = sqrt(numerator + denominator)
        print("lenght: \(result)")
        return result;
    }
    
    func getMidpointX() -> Double {
        let result = (Double(self.x1) + Double(self.x2) / 2) - (75/2)
        return result
    }
    
    func getMidpointY() -> Double {
        let numerator = Double(self.y1) + Double(self.y2) - 75
        let result = numerator / 2
        return result
    }
}