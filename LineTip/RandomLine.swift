//
//  RandomLine.swift
//  LineTip
//
//  Created by Artur Schäfer on 08.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit

/// this class creates random lines for random mode
class RandomLine: LineGenerator {
    
    var middleFieldX: Int
    var viewHeight: Int
    var viewWidth: Double
    var edgeTolerance: Int
    
    init(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.edgeTolerance = 40
        self.viewWidth = Double(screenSize.height)
        self.middleFieldX = Int(viewWidth * 0.5)
        self.viewHeight = Int(screenSize.width) - edgeTolerance
    }
    
    /// generate 20 lines
    func getLines() -> Array<Line> {
        return getLinesByAmount(20)
    }
    
    /// random lines are generated randomly in the whole field (device screen)
    func getLinesByAmount(amount: Int) -> Array<Line> {
        var lines = [Line]()
        
        for _ in 1...amount {
            var x1, x2, y1: Int
            x1 = Random.within(self.edgeTolerance...(self.middleFieldX ))
            x2 = Random.within((self.middleFieldX + self.edgeTolerance)...Int(self.viewWidth))
    
            y1 = Random.within(self.edgeTolerance...(self.viewHeight-self.edgeTolerance))
            
            let line = Line(x1: x1, y1: y1, x2: x2, y2: y1)
            lines.append(line)
            
        }
        return lines
    }
}