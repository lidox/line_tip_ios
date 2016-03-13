//
//  UserManagementUIViewConroller.swift
//  LineTip
//
//  Created by Artur Schäfer on 09.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

/// App starts here.
class UserManagementUIViewConroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var welcomeUIView: UIView!
    @IBOutlet weak var greetUserLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectUserLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var createUserButton: UIButton!
    @IBOutlet weak var settingsNavItem: UIBarButtonItem!
    
    var image : UIImage!
    var medUserList = [MedUser]()
    
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    
        //Disable autolayout constraint error messages in debug console output in Xcode
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        super.viewDidLoad()
        Utils.loadSettingsData()
        
        initTitleAndColors()
        
        medUserList = MedUserManager.fetchMedUsers()
        
        initEmptyView()
    }
    
    /// sets ui elements by key color and texts by selected language
    func initTitleAndColors() {
        welcomeUIView.backgroundColor = UIColor.myKeyColor()
        navigation.title = "LineTip".translate()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.myKeyColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.myKeyColor()
        settingsNavItem.title = "Settings".translate()
        changeButtonColorAndStyle(startButton)
        startButton.setTitle(" " + "Quick Start".translate() + " ", forState: UIControlState.Normal)
        changeButtonColorAndStyle(createUserButton)
        createUserButton.setTitle(" " + "New user".translate() + " ", forState: UIControlState.Normal)
        noDataLabel.text = "Create user".translate()
        greetUserLabel.text = ""
        selectUserLabel.text = "Select User".translate()
        selectUserLabel.textColor = UIColor.myKeyColor()
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    /// sets style and color of an button
    func changeButtonColorAndStyle(button: UIButton) {
        button.setTitleColor(UIColor.myKeyColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.myKeyColor().CGColor
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medUserList.count
    }
    
    /// this table contains all med user stored in database
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = medUserList[indexPath.row].medId
        cell.detailTextLabel!.text = "\(medUserList[indexPath.row].trial!.count) \("trials".translate())"
        cell.textLabel?.textColor = UIColor.myKeyColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // -- BEGINNING: REMOVE FUNCTION --
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "\("Delete".translate())"
    }
    
    /// deletes a user and all of its trials in database and reloads table
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            MedUserManager.deleteMedUserByObjectId(medUserList.removeAtIndex(indexPath.row).objectID)
            self.tableView.reloadData()
            initEmptyView()
        }
    }
    // -- ENDING: REMOVE FUNCTION --
    
    
    /// adds a new user to database by name
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
                self.createUser(textField!.text!)
                self.initEmptyView()
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
    
    /// creates a user if validation is ok
    func createUser(newUserName: String) -> NSManagedObjectID {
        var retObjectId : NSManagedObjectID!
        //if not contains
        var containsName = false
        let newUserName = newUserName.trim()
        self.medUserList = MedUserManager.fetchMedUsers()
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
    
    /// changes view if a user has been seleced
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMainSegue" {
            if let destination = segue.destinationViewController as? MainViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    medUserList = MedUserManager.fetchMedUsers()
                    let selectedUser = medUserList[index]
                    destination.selectedUser = selectedUser
                    destination.selectedUserObjectID = selectedUser.objectID
                }
            }
        }
    }
    
    /// starts a line detection test as quickstart mode (no user selected)
    @IBAction func onQuickStartButton(sender: AnyObject) {
        switchToViewControllerByIdentifier(self, identifier: "line_detection_canvas")
    }
    
    func switchToViewControllerByIdentifier(currentVC: UIViewController, identifier: String){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier(identifier) as! LineDetectionViewController
        
        let selectedUserObjectID = createUser("Quick Start".translate() + "\(NSDate())")
        let user = MedUserManager.fetchMedUserById(selectedUserObjectID)
        
        nextViewController.medUser = user
        nextViewController.selectedUserObjectID = selectedUserObjectID
        nextViewController.isQuickstart = true

        currentVC.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    /// shows user if exists as tableview, else show create user button
    func initEmptyView() {
        if(medUserList.count == 0) {
            print("there is no user to display, so show 'create button'")
            tableView.hidden = true
            selectUserLabel.hidden = true
        }
        else {
            tableView.hidden = false
            selectUserLabel.hidden = false
            print("users will be displayed in table")
        }
        self.view.setNeedsDisplay()
        self.tableView.setNeedsDisplay()
    }
    
    /// switch to user management again if user user clicked on settings before
    func goBack(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    /// adds settings navigation item
    @IBAction func onSettingsClick(sender: AnyObject) {
        let nextViewController:SettingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        let button = UIBarButtonItem(title: "Back".translate(), style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        nextViewController.navigationItem.leftBarButtonItem = button
        nextViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.myKeyColor()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @IBAction func onAddUserBarItemClick(sender: AnyObject) {
        addUser()
    }
    
    @IBAction func onAddUserButtonClick(sender: AnyObject) {
        addUser()
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

/// tricky orientation fix. set orientation to portrait only
extension UINavigationController {
    
    public override func shouldAutorotate() -> Bool {
        return visibleViewController!.shouldAutorotate()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations())!
    }
}

/// fix bug for orientation of the create user alert
extension UIAlertController {
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
}
