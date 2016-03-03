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
    @IBOutlet weak var timeStampTextLabel: UILabel!
    @IBOutlet weak var hitTextLabel: UILabel!
    @IBOutlet weak var missTextLabel: UILabel!
    @IBOutlet weak var durationTextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
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
        
        let lastTrial2 = getLastTrialByObjectId(self.selectedUserObjectID)
        if(lastTrial2.hits != -1){
            timeStampLabel.text = "\(lastTrial2.timeStamp)"
            hitLabel.text = "\(lastTrial2.hits)"
            missLabel.text = "\(lastTrial2.fails)"
            durationLabel.text = "\(lastTrial2.duration)"
        }
        
        initColors()
        initTexts()
    }
    
    func initColors() {
        startButton.backgroundColor = UIColor.myKeyColor()
        timeStampLabel.textColor = UIColor.myKeyColor()
        hitLabel.textColor = UIColor.myKeyColor()
        missLabel.textColor = UIColor.myKeyColor()
        durationLabel.textColor = UIColor.myKeyColor()
        startButton.setTitleColor(UIColor.myKeyColorSecond(), forState: UIControlState.Normal)
        
        //button settings
        startButton.layer.cornerRadius = 7.0
    }
    
    func initTexts() {
        startButton.setTitle("\("NEW TRIAL".translate())", forState: UIControlState.Normal)
        
        titleLabel.text = "\("result view".translate())"
        //print("TITELCOLOR:  \(titleLabel.textColor)")
        //UIColor(red: 0.160784, green: 0.384314, blue: 0.658824, alpha: 1.0)
        //0.160784 0.384314 0.658824 1
        timeStampTextLabel.text = "\("timestamp".translate())"
        hitTextLabel.text = "\("hits".translate())"
        missTextLabel.text = "\("misses".translate())"
        durationTextLabel.text = "\("duration".translate())"
        
    }
    
    
    @IBAction func onStartLineDetection(sender: AnyObject) {
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

    func getLastTrialByObjectId(objectId: NSManagedObjectID) -> Trial {
        let context = DataController().managedObjectContext
        
        do {
            let medUser = try context.existingObjectWithID(self.selectedUserObjectID) as? MedUser
            let trialList = medUser?.trial!.allObjects as! [MedTrial]
            
            let retTrial = Trial()
            retTrial.hits = -1
            if(trialList.count > 0){
                
                //find the latest trial by creationdate
                var lastTrial = trialList.last
                for (index, _) in trialList.enumerate() {
                    let date = trialList[index].creationDate
                    if(lastTrial!.creationDate.isLessThanDate(date)){
                        lastTrial = trialList[index]
                    }
                   
                }
                
                retTrial.hits = (lastTrial?.hits?.integerValue)!
                retTrial.fails = (lastTrial?.fails?.integerValue)!
                retTrial.duration = (lastTrial?.duration?.doubleValue)!
                retTrial.timeStamp = (lastTrial?.timeStamp)!
                retTrial.isSelectedForStats = (lastTrial!.isSelectedForStats!.boolValue)
            }
            return retTrial
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

}
