//
//  ResultsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController {
    

    //labels
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    @IBOutlet weak var missLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var lastTrial = Trial()
    var selectedUser : MedUser!
    var selectedUserObjectID : NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        timeStampLabel.text = "noch kein Versuch durchgeführt"
        hitLabel.text = "0"
        missLabel.text = "0"
        durationLabel.text = "-"
        
        if(lastTrial.hasStarted()){
            timeStampLabel.text = "\(lastTrial.timeStamp)"
            hitLabel.text = "\(lastTrial.hits)"
            missLabel.text = "\(lastTrial.fails)"
            durationLabel.text = "\(lastTrial.duration)"
        }
        print("3. Result")
        //print("resultViewController MED-ID: \(MedUserManager.fetchMedIdByObjectId(self.selectedUserObjectID))")
    }
    
    @IBAction func startLineDetectionBtn(sender: AnyObject) {
        //print("start line detection with user: \(self.selectedUser.medId)")
        
        switchToViewControllerByIdentifier(self, identifier: "line_detection_canvas")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as! LineDetectionViewController
        print("results segue: \(self.selectedUserObjectID)")
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
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
