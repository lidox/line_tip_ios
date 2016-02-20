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
    
    var leftFieldX: Int
    var middleFieldX: Int
    var rightFieldX: Int
    var viewHeight: Int
    var viewWidth: Double
    var edgeTolerance: Int
    
    init(view : UIView){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        self.edgeTolerance = 5
        self.viewWidth = Double(screenSize.height)
        self.leftFieldX = Int(viewWidth * 0.25)
        self.middleFieldX = Int(viewWidth * 0.5)
        self.rightFieldX = Int(viewWidth * 0.75)
        self.viewHeight = Int(screenSize.width) - edgeTolerance
    }
    
    func getLines() -> Array<Line> {
        return getLinesByAmount(2)
    }
    
    func getLinesByAmount(amount: Int) -> Array<Line> {
        var lines = [Line]()
        
        for i in 1...amount {
            // left right order
            var x1, x2, y1: Int
            if(i%2==0){
                x1 = Random.within(self.leftFieldX...self.middleFieldX)
                x2 = Random.within(self.rightFieldX...Int(self.viewWidth))
                //x1 = Utils.randomByInt(self.leftFieldX, to: self.middleFieldX)
                //x2 = Utils.randomByInt(self.rightFieldX, to: Int(self.viewWidth))
            }
            else{
                x1 = Random.within(self.edgeTolerance...self.leftFieldX)
                x2 = Random.within(self.middleFieldX...self.rightFieldX)
                //x1 = Utils.randomByInt(0, to: self.leftFieldX)
                //x2 = Utils.randomByInt(self.middleFieldX, to: self.rightFieldX)
            }
            //y1 = Utils.randomByInt(0, to: self.viewHeight)
            y1 = Random.within(self.edgeTolerance...self.viewHeight)
            
            print("viewWidt:\(viewWidth) and viewHeight:\(viewHeight)")
            print("blocks left: \(leftFieldX) , middle: \(middleFieldX), right: \(rightFieldX)")
            print("generated: \(x1) to \(x2)")
            let line = Line(x1: x1, y1: y1, x2: x2, y2: y1)
            lines.append(line)
            
        }
        return lines
    }}