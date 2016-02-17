//
//  CanvasUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 17.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation


import UIKit

class CanvasUIView: UIView {
    var lines = [Line]()
    let line2 = Line(x1: 105, y1: 70, x2: 401, y2: 70)
    var context = UIGraphicsGetCurrentContext()
    var myImageView  = UIImageView(image: UIImage(named: "trans.png"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("init")
        lines.append(line2)
    }
    
    override func drawRect(rect: CGRect) {
        //print("drawRect")
        draw()
    }
    
    func draw(){
        lines.append(line2)
        context = UIGraphicsGetCurrentContext()
        drawRawLine(lines[0], lineWidth: getLineWidth(), lineColor: getLineColor())
        drawSpot(getImageName(), spotWidth: getSpotWidth(), spotHeight: getSpotHeight(), spotAlpha: 1, line: lines[0])
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
    
    //hier weiter
    func setBackgroundColorUV(color: UIColor) {
        //CGContextSetRGBFillColor(context, <#T##red: CGFloat##CGFloat#>, <#T##green: CGFloat##CGFloat#>, <#T##blue: CGFloat##CGFloat#>, <#T##alpha: CGFloat##CGFloat#>)
    }
    
    
    
    
    
    
    
    
    
}
