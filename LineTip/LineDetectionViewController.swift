//
//  LineDetectionViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 07.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

class LineDetectionViewController: UIViewController {
    
    @IBOutlet weak var finishImg: UIImageView!
    @IBOutlet var uiView: LineDetectionUIView!
    
    var medUser : MedUser!
    var selectedUserObjectID : NSManagedObjectID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHitListener()
        
        // set orientation
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        
        print("LineDetection with obejectId \(selectedUserObjectID)")
        fetchMedUserById(self.selectedUserObjectID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onHit(img: AnyObject){
        uiView.trial.startCountingTime()
        uiView.trial.countHit()
        uiView.setNeedsDisplay()
        ClickSound.play("good", soundExtension: "wav")
        //print("CONTROLLER Hit line")
    }
    
    func onFinish(img: AnyObject){
        uiView.trial.stopCountigTime()
        print("Trial finished! hits: \(uiView.trial.hits) misses: \(uiView.trial.fails) duration: \(uiView.trial.duration) s timestamp: \(uiView.trial.timeStamp)")
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        addTrialToUser(uiView.trial)
        
        switchToResultViewController()
    }
    func addTrialToUser(givenTrial: Trial) {
        let context = DataController().managedObjectContext
        
        do {
            let medUser = try context.existingObjectWithID(self.selectedUserObjectID) as? MedUser
            let trial = NSEntityDescription.insertNewObjectForEntityForName("MedTrial", inManagedObjectContext: context) as! MedTrial
            
            trial.setValue(givenTrial.hits, forKey: "hits")
            trial.setValue(givenTrial.fails, forKey: "fails")
            trial.setValue(givenTrial.duration, forKey: "duration")
            trial.setValue(givenTrial.timeStamp, forKey: "timeStamp")
            trial.setValue(true, forKey: "isSelectedForStats")
            trial.setValue(givenTrial.creationDate, forKey: "creationDate")
            /*
            let currentDateAsString = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
            //"MMMM d  'at'  h:mm a"	April 2 at 5:00 PM
            // Feb 29, 2016, 4:15 PM
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM d, YYYY, h:mm PM"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
            let expiryDate = dateFormatter.dateFromString(currentDateAsString)
            */
            
            medUser!.addTrial(trial)
            try context.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func switchToResultViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        //self.navigationController!.pushViewController(nextViewController, animated: true)
        let navController = MyNavigationController(rootViewController: nextViewController)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        nextViewController.resultsVC.lastTrial = uiView.trial
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        
        self.presentViewController(navController, animated:true, completion: nil)
        //self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func addHitListener() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onHit:"))
        uiView.myImageView.userInteractionEnabled = true
        uiView.myImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let uiViewGestureRecognizer = UITapGestureRecognizer(target:uiView, action:Selector("onFail:"))
        uiView.userInteractionEnabled = true
        uiView.addGestureRecognizer(uiViewGestureRecognizer)
        
        let finishTrialGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onFinish:"))
        finishImg.userInteractionEnabled = true
        finishImg.addGestureRecognizer(finishTrialGestureRecognizer)
    }
    
    func fetchMedUserById(objectID: NSManagedObjectID )  {
        let moc = DataController().managedObjectContext
        do {
            let user = try moc.existingObjectWithID(objectID) as! MedUser
            print("LineDetection MedUser=\(user.medId)")
            self.medUser = user
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}