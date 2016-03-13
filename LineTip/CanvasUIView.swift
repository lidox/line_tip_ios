//
//  CanvasUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 17.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit

/// This UIView is diplayed in the SettingsViewController inoder to show a preview of the line detection test
class CanvasUIView: UIView {
    var line : Line!
    var context = UIGraphicsGetCurrentContext()
    var myImageView  : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        myImageView  = UIImageView(image: UIImage(named: getImageName()))
        print("CanvasUIView: init")
    }
    
    override func drawRect(rect: CGRect) {
        generateLineByPreviewSize()
        draw()
    }
    
    func draw(){
        print("CanvasUIView: draw")
        context = UIGraphicsGetCurrentContext()
        drawRawLine(line, lineWidth: getLineWidth(), lineColor: getLineColor())
        drawSpot(getImageName(), spotWidth: getSpotWidth(), spotHeight: getSpotHeight(), spotAlpha: 1.0, line: line)
        self.setNeedsDisplay()
    }

    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, spotAlpha: CGFloat, line:Line) -> UIImageView {
        print("CanvasUIView: drawSpot")
        myImageView.alpha = spotAlpha
        
        myImageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: line.getSpotWidth(), height: line.getSpotHeight())
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
    }
    
    func getLineWidth() -> CGFloat {
        let value = Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as? NSNumber
        return CGFloat(value!)
    }
    
    func getSpotWidth() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as? NSNumber
        return value!.doubleValue * 100
    }
    
    func getSpotHeight() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as? NSNumber
        return value!.doubleValue
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
    
    func generateLineByPreviewSize() {
        let screenSize = self.frame.size
        let halfLineWidth = Int(screenSize.width * 0.25)
        let screenWidth = Int(screenSize.width / 2)
        let screenHeight = Int(screenSize.height / 2)
        line = Line(x1: (screenWidth - halfLineWidth), y1: screenHeight, x2: (screenWidth + halfLineWidth), y2: screenHeight)
    }
    
}
