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
  // a: T.Type,
    class func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    class func sayHello(personName: String, alreadyGreeted: Bool) -> String {
            return   personName
    }
    
}