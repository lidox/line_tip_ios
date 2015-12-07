//
//  LineDetectionUIView.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class LineDetectionUIView: UIView {

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
        CGContextMoveToPoint(context, 30, 30)
        CGContextAddLineToPoint(context, 300, 400)
        
        CGContextStrokePath(context)
    }


}
