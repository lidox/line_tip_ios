//
//  LineDetectionUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class LineDetectionUIView: UIView {
    
    var context = UIGraphicsGetCurrentContext()
    var lines = [Line]()
    var trial = Trial()
    var myImageView  = UIImageView(image: UIImage(named: "ball.png"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("init")
        var lineGenerator : LineGenerator
        lineGenerator = getLineGenerator()
        lines = lineGenerator.getLines()
    }
    
    override func drawRect(rect: CGRect) {
        //print("drawRect")
        draw()
    }
    
    func draw(){
        let isLastLineDrawn = trial.overflowCounter == (lines.count)
        if(isLastLineDrawn){
            trial.overflowCounter = 0
        }
        
        print("counter:\(trial.overflowCounter)")
        
        
        if(!trial.hasStarted()){
            context = UIGraphicsGetCurrentContext()
        }
        
        drawRawLine(lines[trial.overflowCounter], lineWidth: getLineWidth(), lineColor: getLineColor())
        drawSpot(getImageName(), spotWidth: getSpotWidth(), spotHeight: getSpotHeight(), spotAlpha: 1, line: lines[trial.overflowCounter])
    }
    
    func onFail(img: AnyObject){
        trial.startCountingTime()
        trial.countMiss()
        print("failed to hit line")
    }
    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        myImageView.alpha = spotAlpha
        myImageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: spotWidth, height: spotHeight)
        self.addSubview(myImageView)
        return myImageView
    }
    
    func drawRawLine(line: Line, lineWidth: CGFloat, lineColor: CGColor) {
        CGContextClearRect(context, self.bounds)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, lineColor)
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        
        CGContextStrokePath(context)
        print("line drawn to: (\(line.x1) / \(line.y1)) to (\(line.x2) / \(line.y2))")
        
    }
    
    func getLineWidth() -> CGFloat {
        return 5.0
    }
    
    func getSpotWidth() -> Double {
        return 75
    }
    
    func getSpotHeight() -> Double {
        return 75
    }
    
    func getImageName() -> String {
        return "ball.png"
    }
    
    func getLineColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    
    func getLineGenerator() -> LineGenerator {
        return PreGeneratedLine()
    }
    
    
  

    


}
