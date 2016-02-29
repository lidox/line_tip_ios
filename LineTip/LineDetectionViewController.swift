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
        
        
        // fetchRequest = NSFetchRequest(entityName: "MedTrial")
        
        do {
            //TODO: hier weiter
            let medUser = try context.existingObjectWithID(self.selectedUserObjectID) as? MedUser
            //var trialList = medUser?.trial?.allObjects as! [MedTrial]
            
            //for var i = 0; i < trialList.count; i++ {
            //var cardData = trialList[i] as! NSDictionary
            //}
            
            let trial = NSEntityDescription.insertNewObjectForEntityForName("MedTrial", inManagedObjectContext: context) as! MedTrial
            
            trial.setValue(givenTrial.hits, forKey: "hits")
            trial.setValue(givenTrial.fails, forKey: "fails")
            trial.setValue(givenTrial.duration, forKey: "duration")
            trial.setValue(givenTrial.timeStamp, forKey: "timeStamp")
            trial.setValue(true, forKey: "isSelectedForStats")
            //@NSManaged var hits: NSNumber?
            //@NSManaged var fails: NSNumber?
            //@NSManaged var timeStamp: NSDate?
            //@NSManaged var duration: NSNumber?
            //@NSManaged var user: MedUser!
            //trial.name = cardData.valueForKey("name") as String
            medUser!.addTrial(trial)
            // we save our entity
            try context.save()
            
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func switchToResultViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        nextViewController.resultsVC.lastTrial = uiView.trial
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        self.presentViewController(nextViewController, animated:true, completion:nil)
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