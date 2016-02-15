//
//  ResultsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startLineDetectionBtn(sender: AnyObject) {
        print("start line detection")
        Utils.switchToViewControllerByIdentifier(self, identifier: "line_detection_canvas")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
