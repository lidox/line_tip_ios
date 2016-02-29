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
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
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
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
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