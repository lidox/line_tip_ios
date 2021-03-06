//
//  MainViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class MainViewController: UIViewController, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var scrollPager: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let resultsVC = ResultsViewController(nibName: "ResultsViewController", bundle: nil)
    let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
    
    var selectedUser : MedUser?
    var selectedUserObjectID : NSManagedObjectID!
    var viewtitle = ""
    var userManager = MedUserManager()

    
    override func viewDidLoad() {
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        super.viewDidLoad()
        addEmailNavItem()
        initMedUserInAllView(self.selectedUserObjectID)
        initTitleAndColors()
        configurePageControl()
        initScrollViews()

    }
    
    /// sets key color and texts to ui elements
    func initTitleAndColors() {
        title = viewtitle
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.myKeyColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.myKeyColor()
    }
    
    /// creates 3 views to be scrolled
    func initScrollViews() {
        scrollView.delegate = self
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        self.scrollView.pagingEnabled = true
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
        
        scrollPager.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    /// set page control to show user which page is activated
    func configurePageControl() {
        self.scrollPager.numberOfPages = 3
        self.scrollPager.currentPage = 0
        self.scrollPager.pageIndicatorTintColor = UIColor.blackColor()
        self.scrollPager.currentPageIndicatorTintColor = UIColor.myKeyColor()
    
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(scrollPager.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        scrollPager.currentPage = Int(pageNumber)
        
        if pageNumber == 0 {
            addEmailNavItem()
        }
        else if pageNumber == 1 {
            self.navigationItem.rightBarButtonItem = nil
            addEmailNavItemForCompleteUsersResult()
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    /// add button to navigation for sending emails
    func addEmailNavItem() {
        if deviceCanSendEmails() {
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "sentMailButtonClicked:"), animated: true)
        }
    }
    
    func addEmailNavItemForCompleteUsersResult() {
        if deviceCanSendEmails() {
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "sendMailForCompleteUsersResultButtonClicked:"), animated: true)
        }
    }
    
    /// opens a new email view to sent results of the trial
    @IBAction func sentMailButtonClicked(sender: UIBarButtonItem) {
        let recipient = [""]
        let userMedId = MedUserManager.fetchMedIdByObjectId(self.selectedUserObjectID)
        let subject = "[Line Detection Test] \("Results for user".translate()): \(userMedId)"
        let lastTrial = MedUserManager.getLastTrialByObjectId(self.selectedUserObjectID)
        let messageBody = lastTrial.toString() + "\r\n" + "\("Best regards".translate())," + "\r\n" + "LineTip APP"
        sendEmail(recipient, subject: subject, messageBody: messageBody)
    }
    
    @IBAction func sendMailForCompleteUsersResultButtonClicked(sender: UIBarButtonItem) {
        let recipient = [""]
        let userMedId = userManager.fetchMedUserById(self.selectedUserObjectID).medId
        let subject = "[Line Detection Test] \("Results for user".translate()): \(userMedId)"
        let trialList = userManager.getMedTrialListByObjectId(self.selectedUserObjectID)
        
        var messageBody = ""
        for (index, trial) in trialList.enumerate() {
            messageBody += "\(index+1). " + "trial".translate() + "\r\n"
            messageBody +=  "\("timestamp".translate()): " + "\(trial.timeStamp)"
            messageBody += "\r\n" + "\("hits".translate()): " + "\(trial.hits)" + "\r\n" + "\("misses".translate()): " + "\(trial.fails)" + "\r\n"
            messageBody += "\("duration".translate()): " + "\(Double(trial.duration).getStringAsHoursMinutesSeconds())" + "\r\n"
            messageBody += "-------------" + "\r\n"

        }
        messageBody += "\r\n" + "\("Best regards".translate())," + "\r\n" + "LineTip APP"
        sendEmail(recipient, subject: subject, messageBody: messageBody)
    }
    
    func sendEmail(toRecipients: [String], subject: String, messageBody: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(toRecipients)
            mail.setSubject(subject)
            mail.setMessageBody(messageBody, isHTML: false)
            self.presentViewController(mail, animated: true, completion: nil)
        } else {
            if let
                urlString = ("mailto:\(toRecipients[0])?subject=\(subject)&body=\(messageBody)").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
                url = NSURL(string:urlString) {
                    UIApplication.sharedApplication().openURL(url)
            }
            else {
                print("the device has no e-mail functionality")
            }
        }
    }
    
    func deviceCanSendEmails() -> Bool {
        let sopportsMFMailComposeViewController = MFMailComposeViewController.canSendMail()
        if sopportsMFMailComposeViewController {
            print("device supports: MFMailComposeViewController")
            return true
        }
        
        let supportsMailTo = ("mailto:\("")").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()),
        _ = NSURL(string:supportsMailTo!)
        if (supportsMailTo != nil) {
            print("device supports: supportsMailTo")
            return true
        }
        print("device does not support sending emails")
        return false
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func initMedUserInAllView(objectID: NSManagedObjectID )  {
        let moc = DataController().managedObjectContext
        do {
            selectedUser = try moc.existingObjectWithID(objectID) as? MedUser
            viewtitle = "\("medical ID".translate()): \(selectedUser!.medId)"
            resultsVC.selectedUserObjectID = self.selectedUser?.objectID
            statisticsVC.selectedUserObjectID = self.selectedUser?.objectID
            resultsVC.selectedUser = self.selectedUser
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
    }
    
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
}
