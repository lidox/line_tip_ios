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
    var myImageView  : UIImageView!
    var timer: dispatch_source_t!
    var lineTimer : NSTimer!
    var isTimerActivated = true
    var delayToRedraw : Double!
    var firstTime = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     Initializes the the canvas where the lines will be drawn.
     
     - Parameters:
     - coder: The decoder of the uiview
     
     - Returns: A a list of generated lines
     */
    required init(coder aDecoder: NSCoder) {
        print("LineDetectionUIView: init")
        super.init(coder: aDecoder)!
        self.myImageView  = UIImageView(image: UIImage(named: getImageName()))
        self.delayToRedraw = getDelayToRedrawLines()
        
        var lineGenerator : LineGenerator
        lineGenerator = getLineGenerator()
        lines = lineGenerator.getLines()
    }
    
    override func drawRect(rect: CGRect) {
        print("LineDetectionUIView: drawRect")
        draw()
    }
    
    func draw(){
        let isLastLineDrawn = trial.overflowCounter == (lines.count)
        if(isLastLineDrawn){
            trial.overflowCounter = 0
        }
        
        if(!trial.hasStarted()){
            context = UIGraphicsGetCurrentContext()
        }
        
        let line = lines[trial.overflowCounter]
        drawRawLine(line, lineWidth: getLineWidth(), lineColor: UIColor.whiteColor().CGColor)
        drawSpot(getImageName(), spotWidth: line.getSpotWidth(), spotHeight: line.getSpotHeight(), spotAlpha: 1, line: line)
        self.setNeedsDisplay()
    }
    
    func onFail(img: AnyObject){
        if(firstTime) {
            startResumeLineTimer()
            firstTime = false
        }
        onFail()
    }
    
    func onFail(){
        trial.startCountingTime()
        trial.countMiss()
        ClickSound.play("wrong", soundExtension: "wav")
    }
    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        print("LineDetectionUIView: drawSpot")
        myImageView.alpha = spotAlpha
        myImageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: spotWidth, height: spotHeight)
        self.addSubview(myImageView)
        return myImageView
    }
    
    func drawRawLine(line: Line, lineWidth: CGFloat, lineColor: CGColor) {
        print("LineDetectionUIView: drawRawLine")
        CGContextClearRect(context, self.bounds)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, lineColor)
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        CGContextStrokePath(context)
    }
    
    func getLineWidth() -> CGFloat {
        return CGFloat((Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as! NSNumber))
    }
    
    func getSpotWidth() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as? NSNumber
        return value!.doubleValue
    }
    
    func getSpotHeight() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as? NSNumber
        return value!.doubleValue
    }
    
    func getImageName() -> String {
        return (Utils.getSettingsData(ConfigKey.SPOT_IMAGE_NAME) as? String)!
    }
    
    func getDelayToRedrawLines() -> Double {
        let value = Utils.getSettingsData(ConfigKey.LINE_REDRAW_DELAY) as? NSNumber
        return value!.doubleValue
    }
    
    func getLineGenerator() -> LineGenerator {
        //return PreGeneratedLine()
        return LeftRightLine()
    }
    
    func userToSlow() {
        print("User was not fast enought, so redraw and count miss")
        self.onFail()
        self.trial.overflowCounter++
        self.setNeedsDisplay()
    }

    func startResumeLineTimer() {
        lineTimer = NSTimer.scheduledTimerWithTimeInterval(delayToRedraw, target: self, selector: Selector("userToSlow"), userInfo: nil, repeats: true)
    }
    
}
