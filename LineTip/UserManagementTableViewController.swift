//
//  UserManagementTableViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 30.11.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit

class UserManagementTableViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //var names = [String]()
    var names = ["Max Kieslich", "Artur Schäfer", "Tim Katz", "Regina Nuss", "Thomas Renerken"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MED IDs"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func addName(sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                self.names.append(textField!.text!)
                self.tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("set count done")
            return names.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
            
            cell!.textLabel!.text = names[indexPath.row]
            print("set labels done")
            return cell!
    }
    
    func tableView(var tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView = self.tableView
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
        print("Row: \(row) value= \(names[row])")
    }

}
