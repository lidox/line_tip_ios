//
//  LeftRightLine.swift
//  LineTip
//
//  Created by Artur Schäfer on 19.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit

class LeftRightLine: LineGenerator {
    
    var leftFieldX1: Int
    var leftFieldX2: Int
    var middleFieldX: Int
    var rightFieldX1: Int
    var rightFieldX2: Int
    var viewHeight: Int
    var viewWidth: Double
    var edgeTolerance: Int
    
    init(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.edgeTolerance = 10
        self.viewWidth = Double(screenSize.height)
        self.leftFieldX1 = Int(viewWidth * 0.17)
        self.leftFieldX2 = Int(viewWidth * 0.34)
        self.middleFieldX = Int(viewWidth * 0.5)
        self.rightFieldX1 = Int(viewWidth * 0.67)
        self.rightFieldX2 = Int(viewWidth * 0.84)
        self.viewHeight = Int(screenSize.width) - edgeTolerance
    }
    
    func getLines() -> Array<Line> {
        return getLinesByAmount(20)
    }
    
    func getLinesByAmount(amount: Int) -> Array<Line> {
        var lines = [Line]()
        
        for i in 1...amount {
            // left right order
            var x1, x2, y1: Int
            if(i%2==0){
                x1 = Random.within(self.middleFieldX...self.rightFieldX1)
                x2 = Random.within(self.rightFieldX2...Int(self.viewWidth))
            }
            else{
                x1 = Random.within(self.edgeTolerance...self.leftFieldX1)
                x2 = Random.within(self.leftFieldX2...self.middleFieldX)
            }
            y1 = Random.within(self.edgeTolerance...(self.viewHeight-self.edgeTolerance))
            
            //print("viewWidt:\(viewWidth) and viewHeight:\(viewHeight)")
            //print("blocks left: \(leftFieldX) , middle: \(middleFieldX), right: \(rightFieldX)")
            //print("generated: \(x1) to \(x2)")
            let line = Line(x1: x1, y1: y1, x2: x2, y2: y1)
            lines.append(line)
            
        }
        return lines
    }}