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
    
    /// switch the view controller by identifier
    class func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    /*
    Image Resizing Techniques

    class func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    */
    
    /*
    /// print random lines to console for tests
    class func printLinesToConsole(){
        for var index = 0; index < 10; ++index {
            let y = random(200, to: 600)
            print("let line\(index) = Line(x1: \(random(10, to: 100)), y1: \(y), x2: \(random(150, to: 500)), y2: \(y))")
            print("lines.append(line\(index))")
        }
        
    }
    
    /// generates random UInt32
    class func random(from: UInt32, to: UInt32) -> UInt32 {
        return arc4random_uniform(to) + from
    }
    
    /// generates random Int
    class func randomByInt(from: Int, to: Int) -> Int {
        return Int(arc4random_uniform(UInt32(to)) + UInt32(from))
    }
    */
    
    
    /// save data via nsuserdefaults by key
    class func setSettingsData(key :String, value: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    
    /// read data via nsuserdefaults by key
    class func getSettingsData(key :String) -> AnyObject {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let value = defaults.valueForKey(key) {
            return value
        }
        return 0
    }
    
    /// loads saved data at app start
    class func loadSettingsData(){
        
        var settingsList = [String]()
        settingsList.append(ConfigKey.LINE_WIDTH)
        settingsList.append(ConfigKey.LINE_REDRAW_DELAY)
        settingsList.append(ConfigKey.SPOT_HEIGHT)
        settingsList.append(ConfigKey.SPOT_WIDTH)
        settingsList.append(ConfigKey.SPOT_IMAGE_NAME)
        settingsList.append(ConfigKey.LINE_BROADNESS)
        settingsList.append(ConfigKey.LINE_RANDOM_GENERATION)
        settingsList.append(ConfigKey.LINE_TIMER_ACTIVATED)
        settingsList.append(ConfigKey.TRANSLATION)
        
        for (index, item) in settingsList.enumerate() {
            let test = Utils.getSettingsData(item)
            
            if(test  as! NSObject == 0){
                print("could not load settings data for key: \(item) . So use defaults")
                
                if(item == ConfigKey.LINE_WIDTH){
                    Utils.setSettingsData(ConfigKey.LINE_WIDTH, value: 5.0)
                }
                else if(item == ConfigKey.LINE_RANDOM_GENERATION){
                    Utils.setSettingsData(ConfigKey.LINE_RANDOM_GENERATION, value: false)
                }
                else if(item == ConfigKey.LINE_TIMER_ACTIVATED){
                    Utils.setSettingsData(ConfigKey.LINE_TIMER_ACTIVATED, value: true)
                }
                else if(item == ConfigKey.LINE_REDRAW_DELAY){
                    Utils.setSettingsData(ConfigKey.LINE_REDRAW_DELAY, value: 5.0)
                }
                else if(item == ConfigKey.SPOT_HEIGHT){
                    Utils.setSettingsData(ConfigKey.SPOT_HEIGHT, value: 70.0)
                }
                else if(item == ConfigKey.SPOT_IMAGE_NAME){
                    Utils.setSettingsData(ConfigKey.SPOT_IMAGE_NAME, value: "trans.png")
                }
                else if(item == ConfigKey.SPOT_WIDTH){
                    Utils.setSettingsData(ConfigKey.SPOT_WIDTH, value: 0.23)
                }
                else if(item == ConfigKey.LINE_BROADNESS){
                    Utils.setSettingsData(ConfigKey.LINE_BROADNESS, value: 5.0)
                }
                else if(item == ConfigKey.TRANSLATION){
                    Utils.setSettingsData(ConfigKey.TRANSLATION, value: "DE")
                }
            }
            else{
                print("loaded settings data for key: \(item) at pos: \(index)")
            }
        }
    }
    
    /// Reads the global line width from the NSUserDefaults.
    ///
    /// :returns: the line width
    class func getLineWidth() -> CGFloat {
        let value = Utils.getSettingsData(ConfigKey.LINE_BROADNESS) as? NSNumber
        return CGFloat(value!)
    }
    
    /*
    /// Reads the global spot width from the NSUserDefaults.
    ///
    /// :returns: the spot width
    class func getSpotWidth() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_WIDTH) as? NSNumber
        return value!.doubleValue * 100
    }
    
    /// Reads the global spot height from the NSUserDefaults.
    ///
    /// :returns: the spot height
    class func getSpotHeight() -> Double {
        let value = Utils.getSettingsData(ConfigKey.SPOT_HEIGHT) as? NSNumber
        return value!.doubleValue
    }
    */

    /// Reads the global image name of the spot from the NSUserDefaults.
    ///
    /// :returns: the spots image name
    class func getSpotImageName() -> String {
        return "trans.png"
    }
    
    /// Reads the global line color from the NSUserDefaults.
    ///
    /// :returns: the line color
    class func getLineColor() -> CGColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [255, 255, 255, 255]
        let color = CGColorCreate(colorSpace, components)
        return color!
    }
    
    /// Reads the global delay for redrawing a line, if user takes to long to tap onto the line spot.
    ///
    /// :returns: delay to redraw a line if user misses the spot during the delay time
    class func getDelayToRedrawLines() -> Double {
        let value = Utils.getSettingsData(ConfigKey.LINE_REDRAW_DELAY) as? NSNumber
        return value!.doubleValue
    }
    
    /// Reads the global line modus. Decide between Random or LeftRightModus
    ///
    /// :returns: the modus saved in nsuserdefaults
    class func getLineGenerator() -> LineGenerator {
        let isRandomLine = Utils.getSettingsData(ConfigKey.LINE_RANDOM_GENERATION) as! Bool
        if isRandomLine {
            return RandomLine()
        }
        
        return LeftRightLine()
    }
}



/*
struct Random {
    
    static func within<B: protocol<Comparable, ForwardIndexType>>(range: ClosedInterval<B>) -> B {
        let inclusiveDistance = range.start.distanceTo(range.end).successor()
        let randomAdvance = B.Distance(arc4random_uniform(UInt32(inclusiveDistance.toIntMax())).toIntMax())
        return range.start.advancedBy(randomAdvance)
    }
    
    static func within(range: ClosedInterval<Float>) -> Float {
        return (range.end - range.start) * Float(Float(arc4random()) / Float(UInt32.max)) + range.start
    }
    
    static func within(range: ClosedInterval<Double>) -> Double {
        return (range.end - range.start) * Double(Double(arc4random()) / Double(UInt32.max)) + range.start
    }
    
    static func generate() -> Int {
        return Random.within(0...1)
    }
    
    static func generate() -> Bool {
        return Random.generate() == 0
    }
    
    static func generate() -> Float {
        return Random.within(0.0...1.0)
    }
    
    static func generate() -> Double {
        return Random.within(0.0...1.0)
    }
}
*/

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}


extension Double {
    /// Transforms a double value in seconds to string tupel (h,m,s)
    ///
    /// :returns: a tuple (h,m,s)
    func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {
        let seconds = Int(self)
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    /// Transforms a double value in seconds to string in format hh:MM:ss
    ///
    /// :returns: a formated string hh:mm:ss
    func getStringAsHoursMinutesSeconds () -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds ()
        var retString = "";
        if(h != 0){
            retString = "\(h) h "
        }
        if(m != 0){
            retString += "\(m) min "
        }
        retString += "\(s) s"
        
        return retString
    }
}

/*
// get instance by reflaction: e.g: NSObject.fromClassName(controllerName) as! UIViewController
extension NSObject {
    class func fromClassName(className : String) -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}
*/

/*
extension String {
    func translate() -> String {
        let language = Utils.getSettingsData(ConfigKey.TRANSLATION) as! String
        let translation = myTranslation(self, language: language)
        
        return translation
    }
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func myTranslation(key: String, language: String) -> String {
        var translation = key
        if(language == "DE") {
            if key == "trials" {
                translation = "Versuche"
            }
            else if key == "trial" {
                translation = "Versuch"
            }
            else if key == "user management" {
                translation = "Benutzerverwaltung"
            }
            else if key == "result view" {
                translation = "Ergebnisansicht"
            }
            else if key == "medical ID" {
                translation = "MED ID"
            }
            else if key == "NEW TRIAL" {
                translation = " Neuer Versuch"
            }
            else if key == "duration" {
                translation = "Versuchdauer"
            }
            else if key == "timestamp" {
                translation = "Versuchszeitpunkt"
            }
            else if key == "hits" {
                translation = "Treffer"
            }
            else if key == "misses" {
                translation = "Fehlversuche"
            }
            else if key == "measurement results" {
                translation = "Versuchsergebnisse"
            }
            else if key == "New user" {
                translation = "Neuer Benutzer"
            }
            else if key == "Create user" {
                translation = "Erstelle einen Benutzer"
            }
            else if key == "Save" {
                translation = "Speichern"
            }
            else if key == "Cancel" {
                translation = "Abbrechen"
            }
            else if key == "in following colors" {
                translation = "in folgenden Farben"
            }
            else if key == "Delete" {
                translation = "Löschen"
            }
            else if key == "Not enough trials yet" {
                translation = "Bisher zu wenige Versuche durchgeführt"
            }
            else if key == "Settings" {
                translation = "Einstellungen"
            }
            else if key == "Preview" {
                translation = "Vorschau"
            }
            else if key == "Line Width" {
                translation = "Linienstärke"
            }
            else if key == "Spot Width" {
                translation = "Mittelpunkt-Breite"
            }
            else if key == "Spot Height" {
                translation = "Mittelpunkt-Höhe"
            }
            else if key == "Display lines random" {
                translation = "Zufällige Liniendarstellung"
            }
            else if key == "Hit Sound" {
                translation = "Treffer-Ton"
            }
            else if key == "Miss Sound" {
                translation = "Verfehlt-Ton"
            }
            else if key == "Line Timer" {
                translation = "Linien-Timer"
            }
            else if key == "Line Timer Off" {
                translation = "Linien-Timer Aus"
            }
            else if key == "Draw every 5 s" {
                translation = "Alle 5 s neue Linie"
            }
            else if key == "Results for user" {
                translation = "Ergebniss für den Benutzer"
            }
            else if key == "Best regards" {
                translation = "Beste Grüße"
            }
            else if key == "Select User" {
                translation = "Wähle einen Benutzer"
            }
            else if key == "Quick Start" {
                translation = "Schnellstart"
            }
            else if key == "Assign Trial" {
                translation = "Versuchszuordnung"
            }
            else if key == "Please assign trial(s) to a user." {
                translation = "Bitte ordnen Sie den Versuch einem Benutzer zu."
            }
            else if key == "There is no user to assign" {
                translation = "Kein Benutzer vorhanden"
            }
            else if key == "Please create a new user to assign the trial(s)." {
                translation = "Bitte erstellen sie einen neuen Benutzer."
            }
            else if key == "Back" {
                translation = "Zurück"
            }
            else if key == "no trial yet" {
                translation = "bisher keine Versuche"
            }
            else if key == "Delete selected trial" {
                translation = "Ausgewählten Versuch löschen"
            }
            /*

            */
        }
        
        if(translation == "EN" ) {
            return key
        }
        return translation
    }
}
*/
