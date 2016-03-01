//
//  MainViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var medIdLabel: UILabel!
    
    let resultsVC = ResultsViewController(nibName: "ResultsViewController", bundle: nil)
    let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
    
    var selectedUser : MedUser?
    var selectedUserObjectID : NSManagedObjectID!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMedUserInAllView(self.selectedUserObjectID)
        print("1. MainController with obejct-id= \(self.selectedUserObjectID)")
        initScrollViews()
    }
    
    
    func initScrollViews() {
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.addChildViewController(resultsVC)
        resultsVC.view.frame = self.view.bounds
        self.scrollView.addSubview(resultsVC.view)
        resultsVC.didMoveToParentViewController(self)
        
        
        
        statisticsVC.view.frame = self.view.bounds
        var frame1 = statisticsVC.view.frame
        frame1.origin.x = self.view.frame.size.width
        statisticsVC.view.frame = frame1;
        
        
        self.addChildViewController(statisticsVC)
        self.scrollView.addSubview(statisticsVC.view)
        statisticsVC.didMoveToParentViewController(self)
        
        
        let vc2 = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        vc2.view.frame = self.view.bounds
        var frame2 = vc2.view.frame
        frame2.origin.x = self.view.frame.size.width * 2
        vc2.view.frame = frame2;
        
        self.addChildViewController(vc2)
        self.scrollView.addSubview(vc2.view)
        vc2.didMoveToParentViewController(self)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height - 66)
    }
    
    func initMedUserInAllView(objectID: NSManagedObjectID )  {
        let moc = DataController().managedObjectContext
        do {
            selectedUser = try moc.existingObjectWithID(objectID) as? MedUser
            medIdLabel.text = "Med-ID: \(selectedUser!.medId)"
            resultsVC.selectedUserObjectID = self.selectedUser?.objectID
            statisticsVC.selectedUserObjectID = self.selectedUser?.objectID
            resultsVC.selectedUser = self.selectedUser
            //print("fetched user: \(selectedUser!.medId)")
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}
