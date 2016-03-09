//
//  UserManagementUIViewConroller.swift
//  LineTip
//
//  Created by Artur Schäfer on 09.03.16.
//  Copyright © 2016 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

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
    
    @IBAction func onAddUserBarItemClick(sender: AnyObject) {
        addUser()
    }
    
    @IBAction func onAddUserButtonClick(sender: AnyObject) {
        addUser()
    }
    
    func initTitleAndColors() {
        welcomeUIView.backgroundColor = UIColor.myKeyColor()
        navigation.title = "LineTip".translate()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.myKeyColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.tintColor = UIColor.myKeyColor()
        
        settingsNavItem.title = "Settings".translate()
        changeButtonColorAndStyle(startButton)
        startButton.setTitle(" " + "NEW TRIAL".translate() + " ", forState: UIControlState.Normal)
        changeButtonColorAndStyle(createUserButton)
        createUserButton.setTitle(" " + "New user".translate() + " ", forState: UIControlState.Normal)
        noDataLabel.text = "Create user".translate()
        greetUserLabel.text = ""
        selectUserLabel.text = "Select User".translate()
        selectUserLabel.textColor = UIColor.myKeyColor()
        
        startButton.layer.borderColor = UIColor.whiteColor().CGColor
        startButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = medUserList[indexPath.row].medId
        cell.detailTextLabel!.text = "\(medUserList[indexPath.row].trial!.count) \("trials".translate())"
        cell.textLabel?.textColor = UIColor.myKeyColor()
        
        /*
        //Change cell's tint color
        cell.tintColor = UIColor.myKeyColor()
        //Set UITableViewCellAccessoryType.Checkmark here if necessary
        cell.accessoryType = .Checkmark
        */
        
        /*
        let chevron = UIImage(named: "chevron.png")
        cell.accessoryType = .DisclosureIndicator
        cell.accessoryView = UIImageView(image: chevron!)
        */
        
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            MedUserManager.deleteMedUserByObjectId(medUserList.removeAtIndex(indexPath.row).objectID)
            self.tableView.reloadData()
        }
    }
    // -- ENDING: REMOVE FUNCTION --
    
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
                
                //if not contains
                var containsName = false
                let newUserName = textField!.text!.trim()
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
                    print("MedUser: '\(newUserName)' already exists")                }
                else{
                    let user = MedUserManager.insertMedUserByName(newUserName)
                    self.medUserList.append(user)
                    self.tableView.reloadData()
                    print("MedUser: '\(newUserName)' added")
                }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMainSegue" {
            if let destination = segue.destinationViewController as? MainViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    medUserList = MedUserManager.fetchMedUsers()
                    let selectedUser = medUserList[index]
                    //print("\(selectedUser.medId) segue")
                    destination.selectedUser = selectedUser
                    destination.selectedUserObjectID = selectedUser.objectID
                }
            }
        }
    }
    
    
    func initEmptyView() {
        if(medUserList.count == 0) {
            print("there is no user to display, so show 'create button'")
            tableView.hidden = true
            selectUserLabel.hidden = true
        }
        else {
            print("users will be displayed in table")
        }
        self.view.setNeedsDisplay()
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
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.blackColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 44)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
}


extension UINavigationController {
    
    public override func shouldAutorotate() -> Bool {
        return visibleViewController!.shouldAutorotate()
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return (visibleViewController?.supportedInterfaceOrientations())!
    }
}

extension UIAlertController {
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
}
