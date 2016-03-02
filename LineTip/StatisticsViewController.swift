//
//  StatisticsViewController.swift
//  LineTip
//
//  Created by Artur Schäfer on 04.12.15.
//  Copyright © 2015 Artur Schäfer. All rights reserved.
//

import UIKit
import QuartzCore
import CoreData

class StatisticsViewController: UIViewController, LineChartDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var label = UILabel()
    var lineChart: LineChart!
    var trialList: [Trial]!
    var selectedUserObjectID : NSManagedObjectID!
    var views: [String: AnyObject]!
    
    var hitValues: [CGFloat] = []
    var failValue: [CGFloat] = []
    var timeStampLabels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "groupcell")
        tableView.delegate = self
        tableView.dataSource = self
        
        trialList = getTrialListByObjectId(self.selectedUserObjectID)
        print("medTrialList size= \(trialList.count)")
        
        initChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        print("tableview 1")
        return trialList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("groupcell", forIndexPath: indexPath) as UITableViewCell
        print("tableview 2")
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("statcell")!
        //self.medUserList = MedUserManager.fetchMedUsers()
        cell.textLabel!.text = "Treffer: \(trialList[indexPath.row].hits)"
        //cell.textLabel.text = self.groupList[indexPath.row]
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        //view.backgroundColor = UIColor.blackColor()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30.00));
        
        txtField.borderStyle = UITextBorderStyle.Line
        txtField.text = "myString"
        txtField.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(txtField)
        return view
    }
    */
    
    func getTrialListByObjectId(objectId: NSManagedObjectID) -> [Trial]
    {
        let context = DataController().managedObjectContext
        var retList = [Trial] ()
        do {
            let medUser = try context.existingObjectWithID(objectId) as? MedUser
            let trialList = medUser?.trial.allObjects as! [MedTrial]
            
            for (index, _) in trialList.enumerate() {
                let trial = Trial()
                trial.hits = Int(trialList[index].hits!)
                trial.fails = Int(trialList[index].fails!)
                trial.duration = trialList[index].duration!.doubleValue
                trial.timeStamp = trialList[index].timeStamp!
                trial.creationDate = trialList[index].creationDate
                retList.append(trial)
            }
            return retList
        } catch {
            fatalError("Failure to read medTrials at getTrialListByObjectId(): \(error)")
        }
    }
    
    func initChart() {
        if(self.trialList.count > 2){
            views = [:]
            label.text = "..."
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = NSTextAlignment.Center
            self.view.addSubview(label)
            views["label"] = label
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: [], metrics: nil, views: views))
            
            //add data
            for (index, _) in trialList.enumerate() {
                timeStampLabels.append(trialList[index].timeStamp)
                hitValues.append(CGFloat(trialList[index].hits))
                failValue.append(CGFloat(trialList[index].fails))
            }
            
            lineChart = LineChart()
            lineChart.animation.enabled = true
            lineChart.area = true
            lineChart.x.labels.visible = true
            lineChart.x.grid.count = 5
            lineChart.y.grid.count = 5
            lineChart.x.labels.values = timeStampLabels
            lineChart.y.labels.visible = true
            lineChart.addLine(hitValues)
            lineChart.addLine(failValue)
            
            lineChart.translatesAutoresizingMaskIntoConstraints = false
            lineChart.delegate = self
            self.view.addSubview(lineChart)
            views["chart"] = lineChart
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))
            // Do any additional setup after loading the view.
            
            views["table"] = tableView
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let height = "\(Int(screenSize.height * 0.65))"
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[table]-|", options: [], metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[chart]-[table(==\(height))]", options: [], metrics: nil, views: views))
        }
    }
    
}
