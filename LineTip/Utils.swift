//
//  Utils.swift
//  LineTip
//
//  Created by Artur Schäfer on 15.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    class func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    class func printLinesToConsole(){
        // let line3 = Line(x1: 0, y1: 500, x2: 400, y2: 500)
        // lines.append(line)
        
        for var index = 0; index < 10; ++index {
            let y = random(200, to: 600)
            print("let line\(index) = Line(x1: \(random(10, to: 100)), y1: \(y), x2: \(random(150, to: 500)), y2: \(y))")
            print("lines.append(line\(index))")
        }
        
    }
    
    class func random(from: UInt32, to: UInt32) -> UInt32 {
        return arc4random_uniform(to) + from
    }
    
    class func setSettingsData(key :String, value: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.setObject(value, forKey: key)
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    class func getSettingsData(key :String) -> AnyObject {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let value = defaults.valueForKey(key) {
            return value
        }
        
        return 0
    }
}