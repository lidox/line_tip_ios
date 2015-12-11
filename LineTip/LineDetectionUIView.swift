//
//  LineDetectionUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class LineDetectionUIView: UIView {

    var line = Line(x1: 0, y1: 100, x2: 400, y2: 100)
    var line2 = Line(x1: 0, y1: 200, x2: 400, y2: 200)
    var line3 = Line(x1: 0, y1: 500, x2: 400, y2: 500)
    
    var context = UIGraphicsGetCurrentContext()
    var lines = [Line]()
    var trial = Trial()
    var myImageView  = UIImageView(image: UIImage(named: "ball.png"))
    
    override func drawRect(rect: CGRect) {
        lines.append(line)
        lines.append(line2)
        lines.append(line3)
        
        drawLine(lines[trial.overflowCounter])
    }
    
    func draw(){
        let isLastLineDrawn = trial.overflowCounter == (lines.count)
        if(isLastLineDrawn){
            trial.overflowCounter = 0
        }
        print("counter:\(trial.overflowCounter)")
        
        
        drawLine(lines[trial.overflowCounter])
    }
    
    func onHit(img: AnyObject){
        print("Hit line")
        //trial.countHit()
        //draw()
    }
    
    func onFail(img: AnyObject){
        print("Failed to hit line")
        //trial.countMiss()
    }
    
    func getLineColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    
    func getLineWidth() -> CGFloat {
        return 5.0
    }
    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        myImageView.alpha = spotAlpha
        myImageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: spotWidth, height: spotHeight)
        self.addSubview(myImageView)
        return myImageView
    }
    
    func drawRawLine(line: Line, lineWidth: CGFloat, lineColor: CGColor) {
        if(trial.hits == 0 && trial.fails == 0){
            context = UIGraphicsGetCurrentContext()
        }
        CGContextClearRect(context, self.bounds)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, lineColor)
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        
        CGContextStrokePath(context)
        print("line drawn to: (\(line.x1) / \(line.y1)) to (\(line.x2) / \(line.y2))")
        
    }
    
    func drawLine(line: Line) {
        drawRawLine(line, lineWidth: getLineWidth(), lineColor: getLineColor())
        drawSpot("ball.png", spotWidth: 75, spotHeight: 75, spotAlpha: 1, line: line)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
  

    


}
