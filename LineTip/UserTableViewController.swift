//
//  UserTableViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    @IBOutlet weak var wellcomeImage: UIImageView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    var medUserList = [MedUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.loadSettingsData()
        
        title = "Benutzerverwaltung"
        
        let imageName = "wellcome.jpg"
        let image = UIImage(named: imageName)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        wellcomeImage.frame = CGRectMake(0,0, screenSize.width, screenSize.height * 0.33)
        wellcomeImage.image = image
        
        
        medUserList = MedUserManager.fetchMedUsers()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medUserList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell")!
        self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = medUserList[indexPath.row].medId
        
        return cell
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      //  let reuseIdentifier = "myCell"
        //var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!// as UITableViewCell?
        //if (cell != nil) {
        //    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        //}
        //cell!.textLabel!.text = names[indexPath.row]
        //cell!.detailTextLabel?.text = "\(names[indexPath.row]) nur genauer"
        
        //let imageName = UIImage(named: "ball")
        //cell!.imageView?.image = imageName
        // cell!.accessoryView = imageName
        
        //return cell!
    //}
    
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
                let newUserName = textField!.text!
                self.medUserList = MedUserManager.fetchMedUsers()
                for user in self.medUserList{
                    let userName = user.medId
                    if(userName == newUserName){
                        containsName = true
                        break
                    }
                }
                
                if(containsName){
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
}
