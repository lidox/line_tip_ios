//
//  LineDetectionUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class LineDetectionUIView: UIView {

    var line = Line(x1: 0, y1: 800, x2: 400, y2: 800)
    var line2 = Line(x1: 20, y1: 200, x2: 400, y2: 200)
    var line3 = Line(x1: 30, y1: 500, x2: 400, y2: 500)
    
    var context = UIGraphicsGetCurrentContext()
    var lines = [Line]()
    var trial = Trial()
    
    override func drawRect(rect: CGRect) {
        lines.append(line)
        lines.append(line2)
        lines.append(line3)
        
        drawRawLine(lines[trial.overflowCounter])
        
        drawSpot("ball.png", spotWidth: 75, spotHeight: 75, spotAlpha: 1, line: lines[trial.overflowCounter])
        
        print("LineDetectionUIView drawRect done: \(lines[trial.overflowCounter].getMidpointX()):\(lines[trial.overflowCounter].getMidpointY())")
        
    }
    
    func draw(){
        let isLastLineDrawn = trial.overflowCounter == (lines.count)
        if(isLastLineDrawn){
            trial.overflowCounter = 0
        }
        print("counter:\(trial.overflowCounter)")
        
        
        drawRawLine(lines[trial.overflowCounter])
        drawSpot("ball.png", spotWidth: 75, spotHeight: 75, spotAlpha: 1, line: self.line)
        
    }
    
    func onHit(img: AnyObject){
        print("Hit line")
        //if()
        //if trial startTime==0 --> start = new date
        trial.countHit()
        draw()
    }
    
    func onFail(img: AnyObject){
        print("Failed to hit line")
        trial.countMiss()
    }
    
    func getColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    
    func getLineWidth() -> CGFloat {
        return 5.0
    }
    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        let imageName = imageNameString
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.alpha = spotAlpha
        imageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: spotWidth, height: spotHeight)
        self.addSubview(imageView)
        
        // tap listener
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onHit:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let uiViewGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onFail:"))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(uiViewGestureRecognizer)
        
        
        return imageView
    }
    
    func drawRawLine(line: Line) {
        if(trial.hits == 0 && trial.fails == 0){
            context = UIGraphicsGetCurrentContext()
        }
        CGContextSetLineWidth(context, getLineWidth())
        CGContextSetStrokeColorWithColor(context, getColor())
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        CGContextStrokePath(context)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
  

    


}
