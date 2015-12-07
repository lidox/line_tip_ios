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
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        // line width
        CGContextSetLineWidth(context, 5.0)
        
        // line color
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        
        CGContextSetStrokeColorWithColor(context, color)
        
        // draw points
        CGContextMoveToPoint(context, CGFloat(line.x1), CGFloat(line.y1))
        CGContextAddLineToPoint(context, CGFloat(line.x2), CGFloat(line.y2))
        
        // image
        let imageName = "ball.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: line.getMidpointX(), y: line.getMidpointY(), width: 75, height: 75)
        self.addSubview(imageView)
        
        print("LineDetectionUIView drawRect done: \(line.getMidpointX()):\(line.getMidpointY())")
        
        CGContextStrokePath(context)
    }


}
