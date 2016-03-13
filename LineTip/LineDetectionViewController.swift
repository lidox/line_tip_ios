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
    
    /// counts hit, starts or restart timer and plays sound, if user hits the spot
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
                uiView.lineTimer.invalidate()
                uiView.startResumeLineTimer()
            }
        }
        uiView.trial.startCountingTime()
        uiView.trial.countHit()
        
        // update the UIView (redraw the line)
        uiView.setNeedsDisplay()
        
        ClickSound.play("good", soundExtension: "wav")
        
    }
    
    /// finishes the line detection test, stops the timer and switches to new view
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
    
    /// adds the trial to the selected user and saves in database
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
    
    /// switches the view controller and sets some paramaters
    func switchToResultViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        let navController = UINavigationController(rootViewController: nextViewController)
        
        nextViewController.resultsVC.lastTrial = uiView.trial
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    /// switches the view controller and sets some paramaters
    func switchToQuickStartViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("quickstart_controller") as! QuickStartUIViewController
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    /// adds a hit listener to spot and the background in order to recognize users touches
    func addHitListener() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onHit:"))
        uiView.spotImage.userInteractionEnabled = true
        uiView.spotImage.addGestureRecognizer(tapGestureRecognizer)
        
        let uiViewGestureRecognizer = UITapGestureRecognizer(target:uiView, action:Selector("onFail:"))
        uiView.userInteractionEnabled = true
        uiView.addGestureRecognizer(uiViewGestureRecognizer)
        
        let finishTrialGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onFinish:"))
        finishImg.userInteractionEnabled = true
        finishImg.addGestureRecognizer(finishTrialGestureRecognizer)
    }
    
    /// reads a meduser by object id
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
    
    /// handles the device orientation
    override internal func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Landscape]
    }
    
    internal override func shouldAutorotate() -> Bool {
        return false
    }
}