//
//  LineDetectionUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class LineDetectionUIView: UIView {
    
    var graphicContext = UIGraphicsGetCurrentContext()
    var linesToDisplay = [Line]()
    var trial = Trial()
    var spotImage  : UIImageView!
    var timer: dispatch_source_t!
    var lineTimer : NSTimer!
    var isTimerActivated : Bool!
    var delayToRedraw : Double!
    var firstTime = true
    var lastTouchPosition : CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// Initializes the the canvas where the lines will be drawn.
    required init(coder aDecoder: NSCoder) {
        print("LineDetectionUIView: init")
        super.init(coder: aDecoder)!
        self.spotImage  = UIImageView(image: UIImage(named: Utils.getSpotImageName()))
        self.delayToRedraw = Utils.getDelayToRedrawLines()
        self.isTimerActivated = Utils.getSettingsData(ConfigKey.LINE_TIMER_ACTIVATED) as! Bool
        
        var lineGenerator : LineGenerator
        lineGenerator = Utils.getLineGenerator()
        linesToDisplay = lineGenerator.getLines()
    }
    
    override func drawRect(rect: CGRect) {
        print("LineDetectionUIView: drawRect")
        draw()
    }
    
    /// Draws the line and its spot.
    /// Following steps are done in this method
    ///
    /// 1. If the last line from linesToDisplay list is drawn, the first line will drawn next by overflowcounter
    /// 2. Creates a new context to draw at the start of the line detection test
    /// 3. Draws the line and its spot
    func draw(){
        let isLastLineDrawn = trial.overflowCounter == (linesToDisplay.count)
        if(isLastLineDrawn){
            trial.overflowCounter = 0
        }
        
        if(!trial.hasStarted()){
            graphicContext = UIGraphicsGetCurrentContext()
        }
        
        let line = linesToDisplay[trial.overflowCounter]
        drawRawLine(line, lineWidth: Utils.getLineWidth(), lineColor: UIColor.whiteColor().CGColor)
        drawSpot(Utils.getSpotImageName(), spotWidth: line.getSpotWidth(), spotHeight: line.getSpotHeight(), spotAlpha: 1, line: line)
        self.setNeedsDisplay()
    }
    
    /// If user misses the the spot this method is called.
    /// If the user clicked first time, the timer starts to count
    func onFail(img: AnyObject){
        if(firstTime) {
            startResumeLineTimer()
            firstTime = false
        }
        onFail()
    }
    
    /// If user misses the the spot this method is called.
    func onFail(){
        trial.startCountingTime()
        trial.countMiss()
        trial.addMissedTouchPosition(lastTouchPosition)
        ClickSound.play("wrong", soundExtension: "wav")
    }
    
    /// Draws the spot into the middle of the given line.
    ///
    /// :param: imageNameString The name of the image to be displayed in the middle of the line
    /// :param: spotWidth The width of the spot to be set
    /// :param: spotHeight The height of the spot to be set
    /// :param: spotAlpha The alpha (opecaty) of the spot to be set
    /// :param: line The line which belongs to be given spot
    /// :returns: the spot image and its configuration
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        print("LineDetectionUIView: drawSpot")
        spotImage.alpha = spotAlpha
        spotImage.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: spotWidth, height: spotHeight)
        self.addSubview(spotImage)
        return spotImage
    }
    
    /// Draws the line to the graph
    ///
    /// :param: line The line to be drawn
    /// :param: lineWidth The width to be set
    /// :param: lineColor The line color to be set
    func drawRawLine(line: Line, lineWidth: CGFloat, lineColor: CGColor) {
        print("LineDetectionUIView: drawRawLine")
        CGContextClearRect(graphicContext, self.bounds)
        CGContextSetLineWidth(graphicContext, lineWidth)
        CGContextSetStrokeColorWithColor(graphicContext, lineColor)
        CGContextMoveToPoint(graphicContext, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(graphicContext, CGFloat(line.x2), CGFloat(line.y2))
        CGContextStrokePath(graphicContext)
    }
    
    /// if the user was to slow to hit the spot of the line a new line will be drawn and a miss will be counted
    func userToSlow() {
        print("User was not fast enought, so redraw line and count miss")
        resetLastTouchPosition()
        self.onFail()
        self.trial.overflowCounter++
        self.setNeedsDisplay()
    }

    /// starts or resume the time, if user was to slow to hit the line
    func startResumeLineTimer() {
        lineTimer = NSTimer.scheduledTimerWithTimeInterval(delayToRedraw, target: self, selector: Selector("userToSlow"), userInfo: nil, repeats: true)
    }
    
    /// reset last touch position to (0,0)
    func resetLastTouchPosition() {
        self.lastTouchPosition.x = 0
        self.lastTouchPosition.y = 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let currentline = linesToDisplay[trial.overflowCounter]
        
        if let touch = touches.first {
            self.lastTouchPosition = touch.locationInView(self)
            //print("(\(currentline.getFlatMidpointX()),\(currentline.getFlatMidpointY()))")
            //print("(\(lastTouchPosition.x),\(lastTouchPosition.y))")
            lastTouchPosition.x = CGFloat(currentline.getFlatMidpointX()) - lastTouchPosition.x
            lastTouchPosition.y = CGFloat(currentline.getFlatMidpointY()) - lastTouchPosition.y
            //print("(\(lastTouchPosition.x),\(lastTouchPosition.y))")
            print(self.trial.getTendencyNameByPosition(lastTouchPosition))
        }
    }
    
}
