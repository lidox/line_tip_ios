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
    var selectedUser : MedUser!
    var selectedUserObjectID : NSManagedObjectID!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad MainController")
        
        resultsVC.selectedUser = self.selectedUser
        resultsVC.selectedUserObjectID = self.selectedUserObjectID
    }
    
    override func viewWillAppear(animated: Bool) {
        if((selectedUser) != nil){
            //selectedUser = MedUserManager.fetchMedUserById(selectedUserObjectID)
            print("viewWIllAppear MainViewController userName= \(selectedUser.medId)")
            resultsVC.selectedUser = self.selectedUser
            medIdLabel.text = "Med-ID: \(selectedUser.medId)"
        }
        initScrollViews()
    }
    
    func initScrollViews() {
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.addChildViewController(resultsVC)
        resultsVC.view.frame = self.view.bounds
        self.scrollView.addSubview(resultsVC.view)
        resultsVC.didMoveToParentViewController(self)
        
        
        let vc1 = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        vc1.view.frame = self.view.bounds
        var frame1 = vc1.view.frame
        frame1.origin.x = self.view.frame.size.width
        vc1.view.frame = frame1;
        
        
        self.addChildViewController(vc1)
        self.scrollView.addSubview(vc1.view)
        vc1.didMoveToParentViewController(self)
        
        
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
}
