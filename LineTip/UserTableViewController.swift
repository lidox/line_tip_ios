//
//  UserTableViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var wellcomeImage: UIImageView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    var medUserList = [MedUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.loadSettingsData()
        
        initTitleAndColors()
        initWelcomeImage()
        
        medUserList = MedUserManager.fetchMedUsers()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medUserList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = medUserList[indexPath.row].medId
        cell.detailTextLabel!.text = "\(medUserList[indexPath.row].trial.count) \("trials".translate())"
        cell.textLabel?.textColor = UIColor.myKeyColor()
        
        /*
        //cell.accessoryView?.tintColor = UIColor.myKeyColor()
        let onlyUIButtons = cell.subviews.filter { $0 is UIButton }
        for button in onlyUIButtons {
            print("boom baby")
            //button.backgroundColor = UIColor.myKeyColor()
            //button.setTitleColor(UIColor.myKeyColor(), forState: UIControlState.Normal)
        }
        cell.tintColor = UIColor.myKeyColor()
        */

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print("Row: \(row) value= \(medUserList[row].medId)")
    }
    
    @IBAction func addUser(sender: AnyObject) {
        let alert = UIAlertController(title: "Neuer Benutzer",
            message: "Erstelle einen Benutzer",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Speichern",
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
                
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
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
                    print("\(selectedUser.medId) segue")
                    destination.selectedUser = selectedUser
                    destination.selectedUserObjectID = selectedUser.objectID
                }
            }
        }
    }
    
    func initTitleAndColors() {
        navigation.title = "\("user management".translate())"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.myKeyColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        //self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.myKeyColor()
    }
    
    func initWelcomeImage() {
        let imageName = "wellcome_orange.jpg"
        let image = UIImage(named: imageName)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        wellcomeImage.frame = CGRectMake(0,0, screenSize.width, screenSize.height * 0.33)
        wellcomeImage.image = image
    }
}
