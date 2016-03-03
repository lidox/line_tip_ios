//
//  UserTableViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import CoreData

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print("Row: \(row) value= \(medUserList[row].medId)")
    }
    
    // -- BEGINNING: REMOVE FUNCTION --
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //medUserList = MedUserManager.fetchMedUsers()
            medUserList.removeAtIndex(indexPath.row)
            
            let moc = DataController().managedObjectContext
            let personFetch = NSFetchRequest(entityName: "MedUser")

            do{
                
                var fetchedPerson = try moc.executeFetchRequest(personFetch) as! [MedUser]
                // sort by creation date as in the table view:
                fetchedPerson = fetchedPerson.sort({ $0.creationDate.compare($1.creationDate) == .OrderedDescending })
                let userToDelete = fetchedPerson[indexPath.row]
                
                // first delete all trials of object
                for item in userToDelete.trial!{
                    moc.deleteObject(item as! NSManagedObject)
                }
                
                let userName = userToDelete.medId
                
                // now delete object
                moc.deleteObject(userToDelete)
                try moc.save()
                print("removed user: \(userName)")
            } catch let error as NSError {
                print ("Couldn't delete. ERROR: \(error)")
            }

            self.tableView.reloadData()
        }
    }
    // -- ENDING: REMOVE FUNCTION --
    
    @IBAction func addUser(sender: AnyObject) {
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
