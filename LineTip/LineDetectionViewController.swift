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
    var isQuickstart = false
    
    override func viewDidLoad() {
        print("LineDetectionViewController: viewDidLoad")
        super.viewDidLoad()
        
        addHitListener()
        
        // set orientation
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        
        fetchMedUserById(self.selectedUserObjectID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onHit(img: AnyObject){
        if(uiView.isTimerActivated!) {
            if(uiView.firstTime) {
                uiView.startResumeLineTimer()
                uiView.firstTime = false
            }
            else if(uiView.isTimerActivated!) {
                if uiView.lineTimer != nil {
                    uiView.lineTimer.invalidate()
                }
                uiView.startResumeLineTimer()
            }
        }
        uiView.trial.startCountingTime()
        uiView.trial.countHit()
        
        // update the UIView (redraw the line)
        uiView.setNeedsDisplay()
        
        ClickSound.play("good", soundExtension: "wav")
        
    }
    
    func onFinish(img: AnyObject){
        uiView.trial.stopCountigTime()
        print("Trial finished! hits: \(uiView.trial.hits) misses: \(uiView.trial.fails) duration: \(uiView.trial.duration) s timestamp: \(uiView.trial.timeStamp)")
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        addTrialToUser(uiView.trial)
        
        if uiView.lineTimer != nil {
            uiView.lineTimer.invalidate()
        }
        
        if isQuickstart {
            switchToQuickStartViewController()
        }
        else {
            switchToResultViewController()
        }
        
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
        let navController = UINavigationController(rootViewController: nextViewController)
        // Creating a navigation controller with VC1 at the root of the navigation stack.
        
        nextViewController.resultsVC.lastTrial = uiView.trial
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        
        self.presentViewController(navController, animated:true, completion: nil)
        //self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func switchToQuickStartViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("quickstart_controller") as! QuickStartUIViewController
        
        //nextViewController.resultsVC.lastTrial = uiView.trial
        //nextViewController.selectedUserObjectID = self.selectedUserObjectID
        //nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        //nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        
        //self.presentViewController(navController, animated:true, completion: nil)
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
    
    override internal func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Landscape]
    }
    internal override func shouldAutorotate() -> Bool {
        return false
    }
}