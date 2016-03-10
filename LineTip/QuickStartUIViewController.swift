//
//  QuickStartUIViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 10.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//


import UIKit
import CoreData

class QuickStartUIViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var assignUserLabel: UILabel!
    @IBOutlet weak var assignUserSubtitleLabel: UILabel!
    @IBOutlet weak var noUserTitleLabel: UILabel!
    @IBOutlet weak var noUserSubTitleLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var startTrialButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var medUserList = [MedUser]()
    var selectedUserObjectID : NSManagedObjectID!
    
    override func viewDidLoad() {
        print("QuickStartUIViewController: viewDidLoad")
        super.viewDidLoad()
        initTitleAndColors()
        medUserList = MedUserManager.fetchMedUsers()
        addLongPressRecognizer()
    }
    
    func initTitleAndColors() {
        changeButtonColorAndStyle(createUserButton)
        createUserButton.setTitle(" " + "New user".translate() + " ", forState: UIControlState.Normal)
        
        changeButtonColorAndStyle(startTrialButton)
        startTrialButton.setTitle(" " + "NEW TRIAL".translate() + " ", forState: UIControlState.Normal)
        
        assignUserLabel.text = "Assign Trial".translate()
        assignUserLabel.textColor = UIColor.myKeyColor()
        assignUserSubtitleLabel.text = "Please assign trial(s) to a user.".translate()
        noUserTitleLabel.text = "There is no user to assign".translate()
        noUserTitleLabel.textColor = UIColor.myKeyColor()
        noUserSubTitleLabel.text = "Please create a new user to assign the trial(s).".translate()
        placeHolderLabel.text = ""
    }
    
    func changeButtonColorAndStyle(button: UIButton) {
        button.setTitleColor(UIColor.myKeyColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.myKeyColor().CGColor
    }
    
    @IBAction func onCreateUserButtonClick(sender: AnyObject) {
        
    }
    
    @IBAction func onStartTrialButtonClick(sender: AnyObject){
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medUserList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quickstartCell")!
        self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = medUserList[indexPath.row].medId
        cell.detailTextLabel!.text = "\(medUserList[indexPath.row].trial!.count) \("trials".translate())"
        cell.textLabel?.textColor = UIColor.myKeyColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "assignUser:")
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    func assignUser(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(touchPoint) {
                print("long press on: \(indexPath.row)")
                // add trials to new user
                medUserList = MedUserManager.fetchMedUsers()
                let selectedUser = medUserList[indexPath.row]
                let placeHolderUser = MedUserManager.fetchMedUserById(self.selectedUserObjectID)
                
                
                //let trialList = placeHolderUser.getTrialList()
                let trialList = MedUserManager.getMedTrialListByObjectId(placeHolderUser.objectID)
                for trial in trialList {
                    //selectedUser = MedUserManager.fetchMedUsers()[indexPath.row]
                    print(trial)
                    //let createdTrial = MedUserManager.insertMedTrial(trial.duration, fails: trial.fails, hits: trial.hits, timeStamp: trial.timeStamp, isSelectedForStats: trial.isSelectedForStats, creationDate: trial.creationDate, user: selectedUser)
                    trial.user = nil 
                    trial.user = selectedUser
                    //selectedUser.addTrial(trial)
                }
                
                //delete placeholder user
                MedUserManager.deleteMedUserByObjectId(placeHolderUser.objectID)
                
                // switch to results view
                switchToResultViewController()
            }
        }
    }
    
    func switchToResultViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        let navController = UINavigationController(rootViewController: nextViewController)
        nextViewController.resultsVC.lastTrial = MedUserManager.getLastTrialByObjectId(self.selectedUserObjectID)
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        
        self.presentViewController(navController, animated:true, completion: nil)
    }
}
