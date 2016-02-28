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
    var userName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        fetchLastTrial()
        seedPerson()
        //list = MedUserManager.fetchMedUsers() TODO:
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("MainViewController userName= \(userName)")
        resultsVC.userName = self.userName
        medIdLabel.text = "Med-ID: \(userName)"
    }
    
    func seedPerson() {
        
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
    
    func fetchLastTrial() {
        let moc = DataController().managedObjectContext
        let personFetch = NSFetchRequest(entityName: "MedUser")
        
        do {
            let fetchedPerson = try moc.executeFetchRequest(personFetch) as! [MedUser]
            print("fetched person: \(fetchedPerson.last!.medId!)")
            
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
}
