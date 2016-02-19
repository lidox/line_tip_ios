//
//  Utils.swift
//  LineTip
//
//  Created by Artur Schäfer on 15.02.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import Foundation
import UIKit
import Darwin

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
    
    class func randomByInt(from: Int, to: Int) -> Int {
        //return UInt32.random(lower: from, upper: to)
        return Int(arc4random_uniform(UInt32(to)) + UInt32(from))
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
    
    
    class func loadSettingsData(){
        
        var settingsList = [String]()
        settingsList.append(ConfigKey.LINE_WIDTH)
        settingsList.append(ConfigKey.LINE_COLOR_ALPHA)
        settingsList.append(ConfigKey.SPOT_HEIGHT)
        settingsList.append(ConfigKey.SPOT_WIDTH)
        settingsList.append(ConfigKey.SPOT_IMAGE_NAME)
        
        for (index, item) in settingsList.enumerate() {
            //print("Item \(index): \(item)")
            let test = Utils.getSettingsData(item)
            
            if(test  as! NSObject == 0){
                print("could not load settings data for key: \(item) . So use defaults")
                
                if(item == ConfigKey.LINE_WIDTH){
                    Utils.setSettingsData(ConfigKey.LINE_WIDTH, value: 5.0)
                }
                else if(item == ConfigKey.LINE_COLOR_ALPHA){
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_RED, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_GREEN, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_BLUE, value: 255)
                    Utils.setSettingsData(ConfigKey.LINE_COLOR_ALPHA, value: 255)
                }
                else if(item == ConfigKey.SPOT_HEIGHT){
                    Utils.setSettingsData(ConfigKey.SPOT_HEIGHT, value: 75)
                }
                else if(item == ConfigKey.SPOT_IMAGE_NAME){
                    Utils.setSettingsData(ConfigKey.SPOT_IMAGE_NAME, value: "trans.png")
                }
                else if(item == ConfigKey.SPOT_WIDTH){
                    Utils.setSettingsData(ConfigKey.SPOT_WIDTH, value: 75)
                }
            }
            else{
                print("loaded settings data for key: \(item) at pos: \(index)")
            }
        }
        
    }
}



public extension UInt32 {
    public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

public extension Int32 {
    public static func random(lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}




