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
    
    var displayedLine : Line!
    var graphContext = UIGraphicsGetCurrentContext()
    var spotImage  : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        spotImage  = UIImageView(image: UIImage(named: "ball.png"))
        print("CanvasUIView: init")
    }
    
    override func drawRect(rect: CGRect) {
        generateLineByPreviewSize()
        draw()
    }
    
    /// draws the line and spot into the preview
    func draw(){
        print("CanvasUIView: draw")
        graphContext = UIGraphicsGetCurrentContext()
        drawRawLine(displayedLine, lineWidth: Utils.getLineWidth(), lineColor: Utils.getLineColor())
        drawSpot("ball.png", spotWidth: Utils.getSpotWidth(), spotHeight: Utils.getSpotHeight(), spotAlpha: 1.0, line: displayedLine)
        self.setNeedsDisplay()
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
        print("CanvasUIView: drawSpot")
        spotImage.alpha = spotAlpha
        spotImage.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: line.getSpotWidth(), height: line.getSpotHeight())
        self.addSubview(spotImage)
        return spotImage
    }
    
    /// Draws the line to the graph
    ///
    /// :param: line The line to be drawn
    /// :param: lineWidth The width to be set
    /// :param: lineColor The line color to be set
    func drawRawLine(line: Line, lineWidth: CGFloat, lineColor: CGColor) {
        CGContextClearRect(graphContext, self.bounds)
        CGContextSetLineWidth(graphContext, lineWidth)
        CGContextSetStrokeColorWithColor(graphContext, lineColor)
        CGContextMoveToPoint(graphContext, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(graphContext, CGFloat(line.x2), CGFloat(line.y2))
        CGContextStrokePath(graphContext)
    }
    
    /*
    /// Reads the global line width from the NSUserDefaults.
    ///
    /// :returns: the line width
    func getLineWidth() -> CGFloat {
        let value = Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as? NSNumber
        return CGFloat(value!)
    }
    
    /// Reads the global spot width from the NSUserDefaults.
    ///
    /// :returns: the spot width
    func getSpotWidth() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as? NSNumber
        return value!.doubleValue * 100
    }
    
    /// Reads the global spot height from the NSUserDefaults.
    ///
    /// :returns: the spot height
    func getSpotHeight() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as? NSNumber
        return value!.doubleValue
    }
    
    /// Reads the global image name of the spot from the NSUserDefaults.
    ///
    /// :returns: the spots image name
    func getSpotImageName() -> String {
        return "ball.png"
    }
    
    /// Reads the global line color from the NSUserDefaults.
    ///
    /// :returns: the line color
    func getLineColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    */
    
    /// Creates a line which fits to its preview view. 
    /// The line is set to the center.
    func generateLineByPreviewSize() {
        let screenSize = self.frame.size
        let halfLineWidth = Int(screenSize.width * 0.25)
        let screenWidth = Int(screenSize.width / 2)
        let screenHeight = Int(screenSize.height / 2)
        displayedLine = Line(x1: (screenWidth - halfLineWidth), y1: screenHeight, x2: (screenWidth + halfLineWidth), y2: screenHeight)
    }
    
}
