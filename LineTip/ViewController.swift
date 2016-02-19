//
//  ViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 27.11.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.loadSettingsData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLineDetectionBtn(sender: AnyObject) {
        print("line-detection btn clicked");
        
        //Utils.printLinesToConsole()
    }
    
}

