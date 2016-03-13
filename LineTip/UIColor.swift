//
//  UIColor.swift
//  LineTip
//
//  Created by Artur Schäfer on 18.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    /*
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
    */
    
    /// Getting the apps key color
    ///
    /// :returns: the app key color
    class func myKeyColor() -> UIColor {
        return UIColor.orangeColor()
    }
    
    /// Getting the apps second key color
    ///
    /// :returns: the second app key color
    class func myKeyColorSecond() -> UIColor {
        return UIColor.blackColor()
    }
}