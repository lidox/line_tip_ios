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
    
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad with userName \(userName)")
        addHitListener()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onHit(img: AnyObject){
        uiView.trial.startCountingTime()
        uiView.trial.countHit()
        uiView.setNeedsDisplay()
        print("CONTROLLER Hit line")
    }
    
    func onFinish(img: AnyObject){
        uiView.trial.stopCountigTime()
        print("Trial finished! hits: \(uiView.trial.hits) misses: \(uiView.trial.fails) duration: \(uiView.trial.duration) s timestamp: \(uiView.trial.timeStamp)")
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        nextViewController.resultsVC.lastTrial = uiView.trial
        nextViewController.userName = self.userName
        nextViewController.resultsVC.userName = self.userName
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
    
    func seedTrial() {
        
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        // we set up our entity by selecting the entity and context that we're targeting
        let entity = NSEntityDescription.insertNewObjectForEntityForName("MedUser", inManagedObjectContext: moc) as! MedUser
        
        // add our data
        entity.setValue(userName, forKey: "medId")
        
        
        // we save our entity
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}