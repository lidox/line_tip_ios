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
    var context = UIGraphicsGetCurrentContext()
    
    override func drawRect(rect: CGRect) {
        
        drawLine()
        
        drawSpot("ball.png", spotWidth: 75, spotHeight: 75, line: self.line)
        
        print("LineDetectionUIView drawRect done: \(line.getMidpointX()):\(line.getMidpointY())")
        
    }
    
    func onHit(img: AnyObject){
        print("Hit line")
    }
    
    func onFail(img: AnyObject){
        print("Failed to hit line")
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
    
    func drawSpot(imageNameString: String, spotWidth: Double, spotHeight: Double, line: Line) -> UIImageView {
        let imageName = imageNameString
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
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
    
    func drawLine() {
        context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, getLineWidth())
        CGContextSetStrokeColorWithColor(context, getColor())
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        CGContextStrokePath(context)
    }
    
    
    
  

    


}
