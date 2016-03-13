//
//  QuickStartUIViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 10.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//


import UIKit
import CoreData

/// quickstart of line detection test in case the doctor has no time to create a user first
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
    var userManager = MedUserManager()
    
    override func viewDidLoad() {
        print("QuickStartUIViewController: viewDidLoad")
        super.viewDidLoad()
        initTitleAndColors()
        medUserList = userManager.fetchMedUsers()
  
        // remove placeholder user from list
        for (index, item) in medUserList.enumerate() {
            let currentUserEqualsSelectedUser = item.medId == userManager.fetchMedUserById(self.selectedUserObjectID).medId
            if  currentUserEqualsSelectedUser {
                medUserList.removeAtIndex(index)
            }
        }
        
        addLongPressRecognizer()
        initEmptyView()
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
        addUser()
    }
    
    @IBAction func onStartTrialButtonClick(sender: AnyObject){
        switchToViewControllerByIdentifier(self, identifier: "line_detection_canvas", selectedUserObjectID: self.selectedUserObjectID)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medUserList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quickstartCell")!
        if (medUserList[indexPath.row].trial != nil) {
            cell.textLabel!.text = medUserList[indexPath.row].medId
            cell.detailTextLabel!.text = "\(medUserList[indexPath.row].trial!.count) \("trials".translate())"
            cell.textLabel?.textColor = UIColor.myKeyColor()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "assignUser:")
        self.view.addGestureRecognizer(longPressRecognizer)
    }
    
    /// assign the trials to an existing user and delete the placeholder user
    func assignUser(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = longPressGestureRecognizer.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(touchPoint) {
                print("long press on: \(indexPath.row)")
                let selectedUser = medUserList[indexPath.row]
                let placeHolderUser = userManager.fetchMedUserById(self.selectedUserObjectID)
                
                let trialList = userManager.getMedTrialListByObjectId(placeHolderUser.objectID)
                for trial in trialList {
                    trial.user = selectedUser
                }
                
                //delete placeholder user
                userManager.deleteMedUserByObjectId(placeHolderUser.objectID)
                self.selectedUserObjectID = selectedUser.objectID
                switchToResultViewController()
            }
        }
    }
    
    func switchToResultViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("myVCId") as! MainViewController
        let navController = UINavigationController(rootViewController: nextViewController)
        nextViewController.resultsVC.lastTrial = userManager.getLastTrialByObjectId(self.selectedUserObjectID)
        nextViewController.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.resultsVC.selectedUserObjectID = self.selectedUserObjectID
        nextViewController.statisticsVC.selectedUserObjectID = self.selectedUserObjectID
        
        self.presentViewController(navController, animated:true, completion: nil)
    }
    
    func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String, selectedUserObjectID: NSManagedObjectID){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as! LineDetectionViewController
        nextViewController.selectedUserObjectID = selectedUserObjectID
        nextViewController.isQuickstart = true
        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func switchToViewControllerLaunchByIdentifier(currentVC: UIViewController, identifier: String, selectedUserObjectID: NSManagedObjectID){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as! UserManagementUIViewConroller
        let navController = UINavigationController(rootViewController: nextViewController)
        currentVC.presentViewController(navController, animated:true, completion: nil)
    }
    
    /// adds a new user just by changing the name of placeholder user
    func addUser() {
        let alert = UIAlertController(title: "",
            message: "\("Create user".translate())",
            preferredStyle: .Alert)
        alert.view.tintColor = UIColor.myKeyColor()
        
        let attributedString = NSAttributedString(string: "\("New user".translate())", attributes: [
            NSForegroundColorAttributeName : UIColor.myKeyColor()
            ])
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let saveAction = UIAlertAction(title: "\("Save".translate())",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                // rename user
                self.userManager.renameMedUserByObjectId(self.selectedUserObjectID, newName: textField!.text!)
                self.switchToViewControllerLaunchByIdentifier(self, identifier: "launcher", selectedUserObjectID: self.selectedUserObjectID)
        })
        
        let cancelAction = UIAlertAction(title: "\("Cancel".translate())",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func createUser(newUserName: String) -> NSManagedObjectID {
        var retObjectId : NSManagedObjectID!
        //if not contains
        var containsName = false
        let newUserName = newUserName.trim()

        for user in self.medUserList{
            let userName = user.medId
            if(userName == newUserName){
                containsName = true
                break
            }
        }
        if(newUserName == ""){
            print("cannot add emtpy string")
        }
        else if(containsName){
            print("MedUser: '\(newUserName)' already exists")
        }
        else{
            let user = MedUserManager.insertMedUserByName(newUserName)
            retObjectId = user.objectID
            print("klappt: \(retObjectId)")
            self.medUserList.append(user)
            self.tableView.reloadData()
            print("MedUser: '\(newUserName)' added")
        }
        return retObjectId
    }
    
    func initEmptyView() {
        if(medUserList.count == 0) {
            tableView.hidden = true
        }
        else {
            tableView.hidden = false
            print("users will be displayed in table")
        }
        self.view.setNeedsDisplay()
        self.tableView.setNeedsDisplay()
    }
    
}
