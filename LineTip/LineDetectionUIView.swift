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
    
    /**
     Initializes the the canvas where the lines will be drawn.
     
     - Parameters:
     - coder: The decoder of the uiview
     
     - Returns: A a list of generated lines
     */
    required init(coder aDecoder: NSCoder) {
        print("LineDetectionUIView: init")
        super.init(coder: aDecoder)!
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
        drawRawLine(line, lineWidth: getLineWidth(), lineColor: getLineColor())
        drawSpot(getImageName(), spotWidth: line.getSpotWidth(), spotHeight: line.getSpotHeight(), spotAlpha: 1, line: line)
    }
    
    func onFail(img: AnyObject){
        trial.startCountingTime()
        trial.countMiss()
        ClickSound.play("wrong", soundExtension: "wav")
        //print("failed to hit line")
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
        let value = (Utils.getSettingsData(ConfigKey.LINE_WIDTH)) as! NSNumber
        return CGFloat(value.floatValue)
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
    
    func getLineColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let red = Utils.getSettingsData(ConfigKey.LINE_COLOR_RED) as? NSNumber
        let green = Utils.getSettingsData(ConfigKey.LINE_COLOR_GREEN) as? NSNumber
        let blue = Utils.getSettingsData(ConfigKey.LINE_COLOR_BLUE) as? NSNumber
        let alpha = Utils.getSettingsData(ConfigKey.LINE_COLOR_ALPHA) as? NSNumber
        
        let components: [CGFloat] = [CGFloat(red!.floatValue), CGFloat(green!.floatValue), CGFloat(blue!.floatValue), CGFloat(alpha!.floatValue)]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    
    func getLineGenerator() -> LineGenerator {
        //return PreGeneratedLine()
        return LeftRightLine()
    }
    
    
  

    


}
